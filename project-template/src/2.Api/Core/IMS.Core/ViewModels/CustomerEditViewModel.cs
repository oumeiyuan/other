using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Core.ViewModels
{
	/// <summary>
	/// 客户修改视图模型
	/// </summary>
	public class CustomerEditViewModel
	{
		/// <summary>
		/// 构造函数
		/// </summary>
		public CustomerEditViewModel()
		{
			Contacters = new List<ContacterEditViewModel>();
		}

		/// <summary>
		/// 客户Id
		/// </summary>
		public string CustomerId { get; set; }

		/// <summary>
		/// <B style="color:red;">客户名称</B>
		/// </summary>
		[Required(ErrorMessage = "客户名称不能为空。")]
		[StringLength(100, ErrorMessage = "客户名称最大长度不能超过100。")]
		public string CustomerName { get; set; }

		/// <summary>
		/// <B style="color:red;">客户编号</B>
		/// </summary>
		[Required(ErrorMessage = "客户编号不能为空。")]
		[StringLength(100, ErrorMessage = "客户编号最大长度不能超过100。")]
		public string CustomerNo { get; set; } 

		/// <summary>
		/// 客户级别，1：一级，2：二级，3：三级
		/// </summary>
		[Range(1, 3, ErrorMessage = "客户级别的取值应在1~3之间")]
		public int CustomerLevel { get; set; }

		/// <summary>
		/// 客户地址
		/// </summary>
		[StringLength(100, ErrorMessage = "客户地址最大长度不能超过100。")]
		public string CustomerAddress { get; set; }

		/// <summary>
		/// 描述
		/// </summary>
		[StringLength(200, ErrorMessage = "描述最大长度不能超过200。")]
		public string Description { get; set; }

		/// <summary>
		/// 行号
		/// </summary>
		public int RowIndex { get; set; }

		/// <summary>
		/// 联系人集合
		/// </summary>
		public IList<ContacterEditViewModel> Contacters { get; set; }

	}

	/// <summary>
	/// 联系人修改视图模型
	/// </summary>
	public class ContacterEditViewModel
	{
		/// <summary>
		/// 联系人名称
		/// </summary>
		[StringLength(100, ErrorMessage = "联系人名称最大长度不能超过100。")]
		public string ContacterName { get; set; }

		/// <summary>
		/// 性别，0：男，1：女
		/// </summary>
		[Range(0, 1, ErrorMessage = "性别的取值范围应在0~1之间。")]
		public int Sex { get; set; }

		/// <summary>
		/// 移动电话
		/// </summary>
		[StringLength(100, ErrorMessage = "移动电话最大长度不能超过100。")]
		public string MobileTelephone { get; set; }

		/// <summary>
		/// 备注
		/// </summary>
		[StringLength(200, ErrorMessage = "备注最大长度不能超过200。")]
		public string Remark { get; set; }
	}
}
