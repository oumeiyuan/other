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
	public class CustomerMap : EntityTypeConfiguration<Customer>
	{
		/// <summary>
		/// 
		/// </summary>
		public CustomerMap()
		{
			this.ToTable("TDemo_Customer");
			this.HasKey(c => c.CustomerId).Property(c => c.CustomerId).HasColumnType("varchar").HasMaxLength(36);
			this.Property(c => c.CustomerName).HasMaxLength(100).IsRequired();
			this.Property(c => c.CustomerNo).HasMaxLength(100).IsRequired();
			this.Property(c => c.CustomerLevel).IsRequired();
			this.Property(c => c.CustomerAddress).HasMaxLength(100);
			this.Property(c => c.Description).HasMaxLength(200);
			this.Property(c => c.IsDelete).IsRequired();
			this.Property(c => c.RowIndex).IsRequired();
			this.Property(c => c.CreateBy).HasColumnType("varchar").HasMaxLength(36).IsRequired();
			this.Property(c => c.CreateByName).HasMaxLength(100).IsRequired();
			this.Property(c => c.CreateDate).IsRequired();
			this.Property(c => c.LastEditBy).HasColumnType("varchar").HasMaxLength(36).IsRequired();
			this.Property(c => c.LastEditByName).HasMaxLength(100).IsRequired();
			this.Property(c => c.LastEditDate).IsRequired();
		}
	}
}
