using IMS.Repository.SqlServer.Mapping;
using IDPlat.Repository.SqlServer;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IMS.Models;

namespace IMS.Repository.SqlServer
{
    public class IMSDbContext:PlatDbContext
    {
		public DbSet<Customer> Customers { get; set; }

		public DbSet<Contacter> Contacter { get; set; }

        public IMSDbContext(string connectionName = "IMSDB")
            : base(connectionName)
        {

        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
			modelBuilder.Configurations.Add(new CustomerMap());
			modelBuilder.Configurations.Add(new ContacterMap());
            base.OnModelCreating(modelBuilder);
        }
    }
}
