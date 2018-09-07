using System;
using System.Threading.Tasks;
using Microsoft.Owin;
using Owin;
using Microsoft.Owin.Security.OAuth;
using System.Web.Http;
using Newtonsoft.Json;

[assembly: OwinStartup(typeof(WebHost.Startup))]
namespace WebHost
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            PluginConfig.RegisterAllPlugins(app);

            GlobalConfiguration.Configure(WebApiConfig.Register);

            JsonConvert.DefaultSettings = () => new JsonSerializerSettings
            {
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            };

            ConfigureAuth(app);
        }
    }
}
