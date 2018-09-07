using Sapi.Data;
using IMS.Models;
using Sapi.Security.Encryption;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Diagnostics;
using System.Security.Cryptography;
using IDPlat.Repository.SqlServer;
using Sapi.Data.EntityFramework;

namespace IMS.Repository.SqlServer
{
    public class IMSDbInitializer : CreateDatabaseIfNotExists<IMSDbContext>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public override void InitializeDatabase(IMSDbContext context)
        {
            base.InitializeDatabase(context);
        }

        protected override void Seed(IMSDbContext context)
        {
            base.Seed(context);
            new PlatSeed(context).Seed();
            new FlowSeed(context).Seed();
            context.SaveChanges();
        }
    }

    public class IMSDatabase:PlatDatabase
    {
        public override void SetInitializer()
        {
            Database.SetInitializer<IMSDbContext>(new IMSDbInitializer());
        }

        public override void Start()
        {
            var dbContext = new IMSDbContext();
            var objectContext = ((System.Data.Entity.Infrastructure.IObjectContextAdapter)dbContext).ObjectContext;
            var mappingCollection = (System.Data.Entity.Core.Mapping.StorageMappingItemCollection)objectContext.MetadataWorkspace.GetItemCollection(System.Data.Entity.Core.Metadata.Edm.DataSpace.CSSpace);
            mappingCollection.GenerateViews(new System.Collections.Generic.List<System.Data.Entity.Core.Metadata.Edm.EdmSchemaError>());
        }
    }

    public class FlowSeed
    {
        private IMSDbContext context;
        public FlowSeed(IMSDbContext _context)
        {
            context = _context;
        }

        public void Seed()
        {

        }
    }
}
