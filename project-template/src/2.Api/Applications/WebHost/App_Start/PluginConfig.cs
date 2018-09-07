using Autofac;
using Autofac.Integration.WebApi;
using Owin;
using Sapi;
using Sapi.Data;
using Sapi.Data.EntityFramework;
using Sapi.Events;
using Sapi.Logging;
using Sapi.Session;
using Sapi.Caching;
using System;
using System.Reflection;
using System.Web.Http;
using Sapi.Caching.Redis;
using Sapi.Data.Redis;
using StackExchange.Redis;
using System.Configuration;

namespace WebHost
{
    public class PluginConfig
    {
        public static void RegisterAllPlugins(IAppBuilder app)
        {
            var builder = new ContainerBuilder();

            builder.Register(l => new ClaimSession()).As<ISession>().InstancePerLifetimeScope();

            //注册日志
            builder.Register(l => new NLogger()).As<ILogger>().SingleInstance();

            

            builder.Register(l => new DefaultEventBus()).As<IEventBus>()
                .SingleInstance();

            //Redis注入
            builder.Register(l =>
            {
                var redisConnenctionString = ConfigurationManager.ConnectionStrings["RedisDB"].ToString();
                return ConnectionMultiplexer.Connect(redisConnenctionString);
            }).As<IConnectionMultiplexer>().SingleInstance();

            builder.Register(l => new RedisRepository(l.Resolve<IConnectionMultiplexer>())).As<IRedisRepository>();

            //缓存注入

            builder.Register(l => new DefaultCacheContextAccessor()).As<ICacheContextAccessor>();

            builder.Register(l => new RedisCacheHolder(l.Resolve<ICacheContextAccessor>(),l.Resolve<IRedisRepository>()))
                .As<ICacheHolder>()
                .SingleInstance();

            builder.Register(l => new RedisSignals(l.Resolve<IRedisRepository>())).As<ISignals>().SingleInstance();

            Type baseType = typeof(IDependency);
            Type singleType = typeof(ISingletonDependency);


            //需要注入的应用层程序集
            var apiAssemblies = new Assembly[] { Assembly.Load("IDPlat.Core"), Assembly.Load("IMS.Core"),Assembly.Load("Sapi.WebApi")};

            //IDependency的实现类注册为页面生命周期方式
            builder.RegisterAssemblyTypes(apiAssemblies)
                        .Where(type => baseType.IsAssignableFrom(type) && !singleType.IsAssignableFrom(type) && !type.IsAbstract)
                        .AsImplementedInterfaces().PropertiesAutowired()
                        .InstancePerLifetimeScope();


            //ISingletonDependency的实现类注册为单例模式
            builder.RegisterAssemblyTypes(apiAssemblies)
                        .Where(type => singleType.IsAssignableFrom(type) && !type.IsAbstract)
                        .AsImplementedInterfaces()
                        .SingleInstance();

            
            //需要注入的业务层程序集
            var appServiceAssemblies = new Assembly[] { Assembly.Load("IDPlat.Domain"), Assembly.Load("IMS.Domain") };

            //IDependency的实现类注册为页面生命周期方式
            builder.RegisterAssemblyTypes(appServiceAssemblies)
                        .Where(type => baseType.IsAssignableFrom(type) && !singleType.IsAssignableFrom(type) && !type.IsAbstract)
                        .AsImplementedInterfaces().PropertiesAutowired()
                        .InstancePerLifetimeScope();


            //ISingletonDependency的实现类注册为单例模式
            builder.RegisterAssemblyTypes(appServiceAssemblies)
                        .Where(type => singleType.IsAssignableFrom(type) && !type.IsAbstract)
                        .AsImplementedInterfaces()
                        .SingleInstance();

            //需要注入的数据层程序集
			var repositoryAssemblies = new Assembly[] { Assembly.Load("IMS.Repository.SqlServer")};
            //模块注册（将业务自行注册的模块注册进来)
            builder.RegisterAssemblyModules(repositoryAssemblies);

            HttpConfiguration configuration = GlobalConfiguration.Configuration;

            builder.RegisterApiControllers(apiAssemblies).PropertiesAutowired();
            var container = builder.Build();
            configuration.DependencyResolver= new AutofacWebApiDependencyResolver(container);

            app.UseAutofacMiddleware(container);
            app.UseAutofacWebApi(configuration);

            //初始化数据库
            //container.Resolve<IDatabase>().SetInitializer();
            container.Resolve<Sapi.Data.IDatabase>().Start();

            Sapi.IOC.IocManager.SetContainer(container);
        }
    }
}