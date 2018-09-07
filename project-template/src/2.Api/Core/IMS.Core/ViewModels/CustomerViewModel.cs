using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Core.ViewModels
{
	/// <summary>
	/// 客户查看视图模型
	/// </summary>
	public class CustomerViewModel
	{
		/// <summary>
		/// 构造函数
		/// </summary>
		public CustomerViewModel()
		{
			Contacters = new List<ContacterViewModel>();
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
		/// 行号
		/// </summary>
		public int RowIndex { get; set; }

		/// <summary>
		/// 创建者Id
		/// </summary>
		public string CreateBy { get; set; }

		/// <summary>
		/// 创建者名称
		/// </summary>
		public string CreateByName { get; set; }

		/// <summary>
		/// 创建日期
		/// </summary>
		public DateTime CreateDate { get; set; }

		/// <summary>
		/// 最后编辑人ID
		/// </summary>
		public string LastEditBy { get; set; }

		/// <summary>
		/// 最后编辑人名称
		/// </summary>
		public string LastEditByName { get; set; }

		/// <summary>
		/// 最后编辑日期
		/// </summary>
		public DateTime LastEditDate { get; set; }

		/// <summary>
		/// 联系人集合
		/// </summary>
		public IList<ContacterViewModel> Contacters { get; set; }

	}

	/// <summary>
	/// 联系人查询视图模型
	/// </summary>
	public class ContacterViewModel
	{
		/// <summary>
		/// 联系人Id
		/// </summary>
		public string ContacterId { get; set; }

		/// <summary>
		/// 客户Id
		/// </summary>
		public string CustomerId { get; set; }

		/// <summary>
		/// 联系人名称
		/// </summary>
		public string ContacterName { get; set; }

		/// <summary>
		/// 性别，0：男，1：女
		/// </summary>
		public int Sex { get; set; }

		/// <summary>
		/// 移动电话
		/// </summary>
		public string MobileTelephone { get; set; }

		/// <summary>
		/// 备注
		/// </summary>
		public string Remark { get; set; }

		/// <summary>
		/// 行号
		/// </summary>
		public int RowIndex { get; set; }
	}
}
