using Sapi.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Models
{
	/// <summary>
	/// 客户
	/// </summary>
	public class Customer : IEntity
	{
		/// <summary>
		/// 构造函数
		/// </summary>
		public Customer()
		{
			Contacters = new List<Contacter>();
		}

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
		/// 描述
		/// </summary>
		public string Description { get; set; }

		/// <summary>
		/// 标记删除
		/// </summary>
		public bool IsDelete { get; set; }

		/// <summary>
		/// 行号
		/// </summary>
		public int RowIndex { get; set; }

		/// <summary>
		/// 创建人
		/// </summary>
		public string CreateBy { get; set; }

		/// <summary>
		/// 创建人名称
		/// </summary>
		public string CreateByName { get; set; }

		/// <summary>
		/// 创建时间
		/// </summary>
		public DateTime CreateDate { get; set; } 

		/// <summary>
		/// 最后编辑人
		/// </summary>
		public string LastEditBy { get; set; }

		/// <summary>
		/// 最后编辑人名称
		/// </summary>
		public string LastEditByName { get; set; }

		/// <summary>
		/// 最后编辑时间
		/// </summary>
		public DateTime LastEditDate { get; set; }

		/// <summary>
		/// 联系人
		/// </summary>
		public ICollection<Contacter> Contacters { get; set; }
	
	}
}
