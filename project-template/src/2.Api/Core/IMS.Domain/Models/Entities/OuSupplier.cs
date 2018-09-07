using Sapi.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Domain.Models.Entities
{
    /// <summary>
    /// 供应商
    /// </summary>
    class OuSupplier:IEntity
    {
        public OuSupplier()
        {

        }
        /// <summary>
        /// 供方id
        /// </summary>
        public int SupId { get; set; }

        /// <summary>
        /// 供方名称
        /// </summary>
        public string SupName { get; set; }

        /// <summary>
		/// 供方编号
		/// </summary>
        public string SupNo { get; set; }

        /// <summary>
		/// 纳税人类型编号
		/// </summary>
        public string TaxPayerId { get; set; }

        /// <summary>
		/// 纳税人类型名称
		/// </summary>
        public string TaxPayerName { get; set; }

        /// <summary>
		/// 企业类型
		/// </summary>
        public string EnterpriseForm { get; set; }

        /// <summary>
		/// 统一社会信用代码
		/// </summary>
        public string CreditCode { get; set; }

        /// <summary>
		/// 法定代表人
		/// </summary>
        public string LegalRepresentative { get; set; }

        /// <summary>
		/// 注册资本
		/// </summary>
        public string RegisteredCapital { get; set; }

        /// <summary>
		/// 公司地址
		/// </summary>
        public string Address { get; set; }

        /// <summary>
        /// 邮政编码
        /// </summary>
        public string Postalcode { get; set; }

        /// <summary>
        /// 公司电话
        /// </summary>
        public string OfficePhone { get; set; }

        /// <summary>
        /// 公司传真
        /// </summary>
        public string FaxNumber { get; set; }

        /// <summary>
        /// 公司电子邮箱
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// OfficialWebsite
        /// </summary>
        public string OfficialWebsite { get; set; }

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





    }
}
