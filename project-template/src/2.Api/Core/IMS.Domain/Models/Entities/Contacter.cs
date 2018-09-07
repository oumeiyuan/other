using Sapi.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Models
{
	/// <summary>
	/// 联系人
	/// </summary>
	public class Contacter : IEntity
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
