using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Repository.SqlServer
{
    public class IMSDbContextFactory:IDPlat.Repository.SqlServer.DbContextFactory
    {
        public override System.Data.Entity.DbContext Create()
        {
            return new IMSDbContext();
        }
    }
}
