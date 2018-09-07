using Autofac;
using IDPlat.Repositories;
using IDPlat.Repository.SqlServer;
using Sapi;
using Sapi.Data;
using Sapi.Data.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Repository.SqlServer
{
	/// <summary>
	/// 
	/// </summary>
	public class IMSRepositoryModule : RepositoryModule
	{
		/// <summary>
		/// 
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			Type baseType = typeof(IDependency);
			Type singleType = typeof(ISingletonDependency);
			var repositoryAssemblies = new Assembly[] { Assembly.Load("IDPlat.Repository.SqlServer"), Assembly.Load("IMS.Repository.SqlServer") };
            
			//IDependency的实现类注册为页面生命周期方式
			builder.RegisterAssemblyTypes(repositoryAssemblies)
						.Where(type => baseType.IsAssignableFrom(type) && !singleType.IsAssignableFrom(type) && !type.IsAbstract)
						.Except<LogRepository>()
						.Except<PlatDatabase>()
						.AsImplementedInterfaces().PropertiesAutowired()
						.InstancePerLifetimeScope();

			builder.Register(l => new IMSDbContextFactory()).As<IDbContextFactory>().SingleInstance();
			builder.Register(l => new IMSDatabase()).As<IDatabase>();

			builder.Register(l => new RepositoryContext(l.Resolve<IDbContextFactory>())).As<IUnitOfWork>()
				.AsImplementedInterfaces()
				.InstancePerLifetimeScope();

			builder.RegisterType<LogDbContextFactory>().SingleInstance();
			builder.Register(l => new LogRepository(
				new RepositoryContext(l.Resolve<LogDbContextFactory>())
			 )).As<ILogRepository>(); 
		}

		private class LogDbContextFactory : IDbContextFactory
		{
			public virtual DbContext Create()
			{
				return new LogDbContext();
			}
		}
		
	}
}
