using IDPlat.Models;
using IMS.Models;
using Sapi.Services;
using Sapi.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Services
{
	/// <summary>
	/// 示例服务
	/// </summary>
	public interface ICustomerService : IBusinessService
	{
		/// <summary>
		/// 新增客户
		/// </summary>
		/// <param name="customer">客户</param>
		/// <returns></returns>
		bool AddCustomer(Customer customer);

		/// <summary>
		/// 修改客户
		/// </summary>
		/// <param name="customer">客户</param>
		/// <returns></returns>
		bool EditCustomer(Customer customer);

		/// <summary>
		/// 移除客户
		/// </summary>
		/// <param name="customerId">客户Id</param>
		/// <returns></returns>
		bool RemoveCustomer(string customerId);

		/// <summary>
		/// 批量移除客户
		/// </summary>
		/// <param name="customerIds">客户Ids</param>
		/// <returns></returns>
		bool RemoveCustomer(string[] customerIds);

		/// <summary>
		/// 根据客户Id获取客户信息
		/// </summary>
		/// <param name="customerId">客户Id</param>
		/// <returns></returns>
		Customer GetCustomer(string customerId);

		/// <summary>
		/// 获取客户的分页数据
		/// </summary>
		/// <param name="pageIndex">当前页</param>
		/// <param name="pageSize">页面大小，值为0时，表示不进行分页，查询所有有效示例的信息</param>
		/// <param name="sortName">排序字段名，默认值为RowIndex，客户名称：CustomerName；客户编号：CustomerNo；行号：RowIndex</param>
		/// <param name="sortType">排序类型，默认值为ascending，ascending：升序，descending：降序</param>
		/// <param name="keyword">可根据客户名称、客户编号进行模糊查询</param>
		/// <returns></returns>
		PagerResult<CustomerRecord> GetValidPagerCustomers(int pageIndex, int pageSize, string sortName = "RowIndex", string sortType = Constant.SortAsc, string keyword = "");

	}
}
