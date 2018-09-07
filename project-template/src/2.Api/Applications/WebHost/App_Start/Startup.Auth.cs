using Sapi.Logging;
using Microsoft.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using Owin;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web.Http;
using Sapi;
using Sapi.Services;
using Autofac.Integration.Owin;
using Autofac.Integration.WebApi.Owin;
using Autofac;

namespace WebHost
{
	public partial class Startup
	{
		public static OAuthBearerAuthenticationOptions OAuthBearerOptions { get; private set; }

		public void ConfigureAuth(IAppBuilder app)
		{
            OAuthBearerOptions = new OAuthBearerAuthenticationOptions()
            {
                Provider=new QueryStringOAuthBearerProvider()
            };
			var serverOptions = new OAuthAuthorizationServerOptions()
			{
				AllowInsecureHttp = true,
				TokenEndpointPath = new PathString("/Authorize"),
				AccessTokenExpireTimeSpan = TimeSpan.FromMinutes(300),
				Provider = new DefaultAuthorizationServerProvider()
			};
			app.UseOAuthAuthorizationServer(serverOptions);
			app.UseOAuthBearerAuthentication(OAuthBearerOptions);
		}

		public class DefaultAuthorizationServerProvider : OAuthAuthorizationServerProvider
		{
			public DefaultAuthorizationServerProvider()
			{
			}


			public override async Task GrantClientCredentials(OAuthGrantClientCredentialsContext context)
			{
				ILifetimeScope scope = context.OwinContext.GetAutofacLifetimeScope();
				var authService = scope.Resolve<IAuthService>();
				var logger = GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(ILogger)) as ILogger;

				var client = authService.GetClient(context.ClientId);
				if (client == null)
				{
					context.SetError("invalid_client", "找不到有效客户端");
					await Task.FromResult<object>(null);
					return;
				}

				ClaimsIdentity identity = new ClaimsIdentity(context.Options.AuthenticationType);
				identity.AddClaim(new Claim(ClaimTypes.Name, "第三方用户"));
				identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, "ThirdUser"));
				identity.AddClaim(new Claim(ClaimTypes.Surname, "ThirdUser"));
				identity.AddClaim(new Claim("clientId", context.ClientId));
				identity.AddClaim(new Claim("clientName", client.Name));
				var props = new AuthenticationProperties()
				{
					IssuedUtc = DateTime.UtcNow
				};
				var ticket = new AuthenticationTicket(identity, props);
				context.Validated(ticket);

				WriteLog(logger, context.Request, "内部用户", "内部用户", "内部用户", context.ClientId, client.Name);

				await base.GrantClientCredentials(context);
			}

			public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
			{
				ILifetimeScope scope = context.OwinContext.GetAutofacLifetimeScope();
				var authService = scope.Resolve<IAuthService>();
				string clientId;
				string clientSecret;

				if (!context.TryGetBasicCredentials(out clientId, out clientSecret))
				{
					context.SetError("invalid_clientId", string.Format("ClientId为空。"));
					return Task.FromResult<object>(null);
				}
				var client = authService.GetClient(clientId);

				if (client == null)
				{
					context.SetError("invalid_clientId", string.Format("找不到相应的Client。"));
					return Task.FromResult<object>(null);
				}
				if (client.ClientSecret != clientSecret)
				{
					context.SetError("invalid_clientId", string.Format("ClientSecret不正确。"));
					return Task.FromResult<object>(null);
				}
				if (!client.Enabled)
				{
					context.SetError("invalid_clientId", string.Format("Client已禁用。"));
					return Task.FromResult<object>(null);
				}

				context.OwinContext.Set<string>("as:client_id", clientId);
				context.OwinContext.Set<string>("as:clientRefreshTokenLifeTime", client.RefreshTokenLifeTime.ToString());

				context.Validated(clientId);
				return Task.FromResult<object>(null);

			}

			/// <summary>
			/// 
			/// </summary>
			/// <param name="context"></param>
			/// <returns></returns>
			public override async Task GrantCustomExtension(OAuthGrantCustomExtensionContext context)
			{
				ILifetimeScope scope = context.OwinContext.GetAutofacLifetimeScope();
				var authService = scope.Resolve<IAuthService>();
				var logger = GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(ILogger)) as ILogger;
				if (context.GrantType == "sapi")
				{
					string userName = null;
					var userNameValues = context.Parameters.GetValues("userName");
					if (userNameValues != null && userNameValues.Count > 0)
					{
						userName = userNameValues[0];
					}

					var user = authService.GetUser(userName);
					if (user == null)
					{
						context.SetError("invalid_username", string.Format(authService.Message.Content));
						await Task.FromResult<object>(null);
						return;
					}

					var client = authService.GetClient(context.ClientId);
					if (client == null)
					{
						context.SetError("invalid_client", "找不到有效客户端");
						await Task.FromResult<object>(null);
						return;
					}

					ClaimsIdentity identity = new ClaimsIdentity(context.Options.AuthenticationType);

					identity.AddClaim(new Claim(ClaimTypes.Name, user.UserName));
					identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.UserId));
					identity.AddClaim(new Claim(ClaimTypes.Surname, user.AliasName));
					identity.AddClaim(new Claim("clientId", context.ClientId));
					identity.AddClaim(new Claim("clientName", client.Name));
					var props = new AuthenticationProperties()
					{
						IssuedUtc = DateTime.UtcNow
					};
					props.Dictionary.Add("userId", user.UserId);
					var authTicket = new AuthenticationTicket(identity, props);
					context.Validated(authTicket);

					WriteLog(logger, context.Request, user.UserId, user.UserName, user.AliasName, context.ClientId, client.Name);
				}
				await base.GrantCustomExtension(context);
			}


			public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
			{
				ILifetimeScope scope = context.OwinContext.GetAutofacLifetimeScope();
				var authService = scope.Resolve<IAuthService>();
				var logger = GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(ILogger)) as ILogger;
				var user = authService.CheckValid(context.UserName, context.Password);
				if (user == null)
				{
					context.SetError("invalid_username", string.Format(authService.Message.Content));
					await Task.FromResult<object>(null);
					return;
				}

				var client = authService.GetClient(context.ClientId);
				if (client == null)
				{
					context.SetError("invalid_client", "找不到有效客户端");
					await Task.FromResult<object>(null);
					return;
				}

				ClaimsIdentity identity = new ClaimsIdentity(context.Options.AuthenticationType);

				identity.AddClaim(new Claim(ClaimTypes.Name, user.UserName));
				identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.UserId));
				identity.AddClaim(new Claim(ClaimTypes.Surname, user.AliasName));
				identity.AddClaim(new Claim("clientId", context.ClientId));
				identity.AddClaim(new Claim("clientName", client.Name));
				var props = new AuthenticationProperties()
				{
					IssuedUtc = DateTime.UtcNow
				};
				props.Dictionary.Add("userId", user.UserId);
				var ticket = new AuthenticationTicket(identity, props);
				context.Validated(ticket);

				WriteLog(logger, context.Request, user.UserId, user.UserName, user.AliasName, context.ClientId, client.Name);

				await base.GrantResourceOwnerCredentials(context);

			}

			public override Task TokenEndpoint(OAuthTokenEndpointContext context)
			{
				if (context.Properties.Dictionary.ContainsKey("userId"))
				{
					context.AdditionalResponseParameters.Add("userId", context.Properties.Dictionary["userId"]);
				}
				return Task.FromResult<object>(null);
			}

			private void WriteLog(ILogger logger, IOwinRequest request, string userId, string userName, string aliasName, string clientId, string clientName)
            {
                var properties = new Dictionary<string, object>();
				properties.Add("url", this.GetUserLoginAddress(request));
                properties.Add("userAddress", this.GetUserHostAddress(request));
                properties.Add("userId", userId);
                properties.Add("userName", userName);
                properties.Add("userAliasName", aliasName);
                properties.Add("clientId", clientId);
                properties.Add("clientName", clientName);
                properties.Add("infoType", "login");

				logger.Information(properties, "用户登录成功。");
            }

			/// <summary>
			/// 获取登录的api地址
			/// </summary>
			/// <param name="request"></param>
			/// <returns></returns>
			private string GetUserLoginAddress(IOwinRequest request)
			{
				var port = string.Empty;
				if (request.LocalPort.HasValue)
				{
					port = string.Format(":{0}", request.LocalPort);
				}
				return string.Format("{0}://{1}{2}{3}{4}", request.Scheme, request.LocalIpAddress, port, request.PathBase, request.Path);
			}

			/// <summary>
			/// 
			/// </summary>
			/// <param name="request"></param>
			/// <returns></returns>
			private string GetUserHostAddress(IOwinRequest request)
			{
				return request.Headers["X-Real-IP"] ?? request.RemoteIpAddress;
			}
		}

        /// <summary>
        /// 
        /// </summary>
        public class QueryStringOAuthBearerProvider : OAuthBearerAuthenticationProvider
        {
            public override Task RequestToken(OAuthRequestTokenContext context)
            {
                if (!string.IsNullOrEmpty(context.Token))
                {
                    return Task.FromResult<object>(null);
                }

                var value = context.Request.Query.Get("access_token");
                if (!string.IsNullOrEmpty(value))
                {
                    context.Token = value;
                }

                return Task.FromResult<object>(null);
            }
        }
	}

}
