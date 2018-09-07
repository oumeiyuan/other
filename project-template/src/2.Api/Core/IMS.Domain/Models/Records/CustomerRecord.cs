using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Models
{
	/// <summary>
	/// 
	/// </summary>
	public class CustomerRecord
	{
		/// <summary>
		/// 客户Id
		/// </summary>
		public string CustomerId { get; set; }

		/// <summary>
		/// 客户名称
		/// </summary>
		public string CustomerName { get; set; }

		/// <summary>
		/// 客户编号
		/// </summary>
		public string CustomerNo { get; set; }

		/// <summary>
		/// 客户级别，1：一级，2：二级，3：三级
		/// </summary>
		public int CustomerLevel { get; set; }

		/// <summary>
		/// 客户地址
		/// </summary>
		public string CustomerAddress { get; set; }

		/// <summary>
		/// 创建时间
		/// </summary>
		public DateTime CreateDate { get; set; } 

		/// <summary>
		/// 行号
		/// </summary>
		public int RowIndex { get; set; }
	}
}
