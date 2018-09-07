using Sapi.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Models
{
    /// <summary>
    /// 消息提醒码
    /// </summary>
    public class MsgCode
    {
		/// <summary>
		/// 新增失败，已存在一个相同的客户名称。
		/// </summary>
		[Content("新增失败，已存在一个相同的客户名称。")]
		public const int DEMO_CUSTOMER_FOR_ADD_NAME_EXISTS = 510001;

		/// <summary>
		/// 新增失败，已存在一个相同的客户编号。
		/// </summary>
		[Content("新增失败，已存在一个相同的客户编号。")]
		public const int DEMO_CUSTOMER_FOR_ADD_NO_EXISTS = 510002;

		/// <summary>
		/// 修改失败，找不到可修改的客户。
		/// </summary>
		[Content("修改失败，找不到可修改的客户。")]
		public const int DEMO_CUSTOMER_FOR_EDIT_NOT_FOUND = 510003;

		/// <summary>
		/// 修改失败，已存在一个相同的客户名称。
		/// </summary>
		[Content("修改失败，已存在一个相同的客户名称。")]
		public const int DEMO_CUSTOMER_FOR_EDIT_NAME_EXISTS = 510004;

		/// <summary>
		/// 修改失败，已存在一个相同的客户编号。
		/// </summary>
		[Content("修改失败，已存在一个相同的客户编号。")]
		public const int DEMO_CUSTOMER_FOR_EDIT_NO_EXISTS = 510005;

		/// <summary>
		/// 移除失败，找不到可移除的客户。
		/// </summary>
		[Content("移除失败，找不到可移除的客户。")]
		public const int DEMO_CUSTOMER_FOR_DELETE_NOT_FOUND = 510006;
    }
}
