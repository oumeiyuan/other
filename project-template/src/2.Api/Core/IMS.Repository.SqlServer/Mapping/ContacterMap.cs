using IMS.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Repository.SqlServer.Mapping
{
	/// <summary>
	/// 
	/// </summary>
	public class ContacterMap : EntityTypeConfiguration<Contacter>
	{
		/// <summary>
		/// 
		/// </summary>
		public ContacterMap()
		{
			this.ToTable("TDemo_Contacter");
			this.HasKey(c => c.ContacterId).Property(c => c.ContacterId).HasColumnType("varchar").HasMaxLength(36);
			this.Property(c => c.CustomerId).HasColumnType("varchar").HasMaxLength(36).IsRequired();
			this.Property(c => c.ContacterName).HasMaxLength(100).IsRequired();
			this.Property(c => c.Sex).IsRequired();
			this.Property(c => c.MobileTelephone).HasColumnType("varchar").HasMaxLength(100);
			this.Property(c => c.Remark).HasMaxLength(200);
			this.Property(c => c.RowIndex).IsRequired();
		}
	}
}
