using System.Web.Http;
using WebActivatorEx;
using Swashbuckle.Application;
using Swashbuckle.Swagger;
using System.Web.Http.Description;
using System.Linq;
using System.Collections.Generic;
using System.Security.Claims;
using Microsoft.Owin.Security;
using System;
using WebHost;
using System.Reflection;
using System.Web.Http.Controllers;
using System.Web.Compilation;

[assembly: PreApplicationStartMethod(typeof(SwaggerConfig), "Register")]

namespace WebHost
{
    /// <summary>
    /// 
    /// </summary>
    public class SwaggerConfig
    {
        /// <summary>
        /// 
        /// </summary>
        public static void Register()
        {
            var thisAssembly = typeof(SwaggerConfig).Assembly;

            GlobalConfiguration.Configuration
                .EnableSwagger(c =>
                    {
                        c.SingleApiVersion("v1", "");
						//c.IncludeXmlComments(System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "bin/IDPlat.Core.XML"));
						//c.IncludeXmlComments(System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "bin/IDPlat.Domain.XML"));
                        c.IncludeXmlComments(System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "bin/IMS.Core.XML"));
                        c.IncludeXmlComments(System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "bin/IMS.Domain.XML"));
                        c.OperationFilter<AddFileUploadParams>();
                        c.BasicAuth("Bear").Description("Basic HTTP Authentication");                       
                    })
                .EnableSwaggerUi("apis/{*assetPath}", u => 
                {
                    u.CustomAsset("index", thisAssembly, "WebHost.Swagger.index.html");
                });
        }
    }    
}
