using IDPlat.Models;
using IMS.Models;
using IMS.Repositories;
using Sapi.Data;
using Sapi.Services;
using Sapi.Utility;
using System.Collections.Generic;
using System.Linq;

namespace IMS.Services
{
	/// <summary>
	/// 客户服务 
	/// </summary>
	public class CustomerService : ServiceBase, ICustomerService
	{
		private readonly IUnitOfWork _unitOfWork;
		private readonly ICustomerRepository _customerRepository;
		private readonly IContacterRepository _contacterRepository;

		/// <summary>
		/// 构造函数
		/// </summary>
		/// <param name="unitOfWork"></param>
		/// <param name="customerRepository"></param>
		/// <param name="contacterRepository"></param>
		public CustomerService(IUnitOfWork unitOfWork, 
			ICustomerRepository customerRepository,
			IContacterRepository contacterRepository)
		{
			_unitOfWork = unitOfWork;
			_customerRepository = customerRepository;
			_contacterRepository = contacterRepository;
		}

		/// <summary>
		/// 新增客户
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customer">客户</param>
		/// <returns></returns>
		public bool AddCustomer(Customer customer)
		{
			if (!AddCustomerEnabled(customer))
			{
				return false;
			}
			customer.RowIndex = this.GetCustomerMaxRowIndex();
			_customerRepository.Create(customer);
			if (customer.Contacters != null && customer.Contacters.Count > 0)
			{
				_contacterRepository.CreateRange(customer.Contacters);
			}
			_unitOfWork.Commit();
			return true;
		}

		/// <summary>
		/// 判断客户是否可以新增
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customer">客户</param>
		/// <returns></returns>
		private bool AddCustomerEnabled(Customer customer)
		{
			if (_customerRepository.Table.Any(c => c.IsDelete == false && c.CustomerName == customer.CustomerName))
			{
				this.Message = new Message(MsgCode.DEMO_CUSTOMER_FOR_ADD_NAME_EXISTS, "新增失败，已存在一个相同的客户名称。");
				return false;
			}
			if (_customerRepository.Table.Any(c => c.IsDelete == false && c.CustomerNo == customer.CustomerNo))
			{
				this.Message = new Message(MsgCode.DEMO_CUSTOMER_FOR_ADD_NO_EXISTS, "新增失败，已存在一个相同的客户编号。");
				return false;
			}
			return true;
		}

		/// <summary>
		/// 修改客户
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customer">客户</param>
		/// <returns></returns>
		public bool EditCustomer(Customer customer)
		{
			var originCustomer = _customerRepository.Get(customer.CustomerId);
			if (!EditCustomerEnabled(originCustomer))
			{
				return false;
			}
			var originContacters = _contacterRepository.Fetch(c => c.CustomerId == originCustomer.CustomerId);

			//可修改以下内容
			originCustomer.CustomerName = customer.CustomerName;
			originCustomer.CustomerNo = customer.CustomerNo;
			originCustomer.CustomerLevel = customer.CustomerLevel;
			originCustomer.CustomerAddress = customer.CustomerAddress;
			originCustomer.Description = customer.Description;
			originCustomer.RowIndex = customer.RowIndex;
			originCustomer.LastEditBy = customer.LastEditBy;
			originCustomer.LastEditByName = customer.LastEditByName;
			originCustomer.LastEditDate = customer.LastEditDate;

			//删除原来的联系人信息
			if (originContacters != null && originContacters.Count() > 0)
			{
				_contacterRepository.DeleteRange(originContacters);
			}
			//更新客户信息
			_customerRepository.Update(originCustomer);  
			//添加现有的联系人信息
			if (customer.Contacters != null && customer.Contacters.Count > 0)
			{
				_contacterRepository.CreateRange(customer.Contacters);
			}
			_unitOfWork.Commit();
			return true;
		}

		/// <summary>
		/// 判断客户是否可以修改
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customer">客户</param>
		/// <returns></returns>
		private bool EditCustomerEnabled(Customer customer)
		{
			if (customer == null)
			{
				this.Message = new Message(MsgCode.DEMO_CUSTOMER_FOR_EDIT_NOT_FOUND, "修改失败，找不到可修改的客户。");
				return false;
			}
			if (_customerRepository.Table.Any(c => c.IsDelete == false && c.CustomerName == customer.CustomerName && c.CustomerId != customer.CustomerId))
			{
				this.Message = new Message(MsgCode.DEMO_CUSTOMER_FOR_EDIT_NAME_EXISTS, "修改失败，已存在一个相同的客户名称。");
				return false;
			}
			if (_customerRepository.Table.Any(c => c.IsDelete == false && c.CustomerNo == customer.CustomerNo && c.CustomerId != customer.CustomerId))
			{
				this.Message = new Message(MsgCode.DEMO_CUSTOMER_FOR_EDIT_NO_EXISTS, "修改失败，已存在一个相同的客户编号。");
				return false;
			}
			return true;
		}

		/// <summary>
		/// 移除客户
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customerId">客户Id</param>
		/// <returns></returns>
		public bool RemoveCustomer(string customerId)
		{
			return RemoveCustomer(new string[] { customerId });
		}

		/// <summary>
		/// 批量移除客户
		/// 作者：杨俊
		/// 日期：2016-12-05
		/// </summary>
		/// <param name="customerIds">客户Ids</param>
		/// <returns></returns>
		public bool RemoveCustomer(string[] customerIds)
		{
			var customers = _customerRepository.Fetch(p => p.IsDelete == false && customerIds.Contains(p.CustomerId));
			//判断客户是否可以移除
			if (!RemoveCustomerEnabled(customers))
			{
				return false;
			}
			foreach (var customer in customers)
			{
				customer.IsDelete = true;
				_customerRepository.Update(customer);
			}
			_unitOfWork.Commit();
			return true;
		}

		/// <summary>
		/// 判断客户是否可以移除
		/// 作者：杨俊
		/// 日期：2017-12-05
		/// </summary>
		/// <param name="customers">客户集合</param>
		/// <returns></returns>
		private bool RemoveCustomerEnabled(IEnumerable<Customer> customers)
		{
			if (customers == null || customers.Count() == 0)
			{
				this.Message = new Message(MsgCode.DEMO_CUSTOMER_FOR_DELETE_NOT_FOUND, "移除失败，找不到可移除的客户。");
				return false;
			}
			return true;
		}

		/// <summary>
		/// 根据客户Id获取客户信息
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customerId">客户Id</param>
		/// <returns></returns>
		public Customer GetCustomer(string customerId)
		{
			var customer = _customerRepository.Get(customerId);
 			customer.Contacters = _contacterRepository.Table.Where(c => c.CustomerId == customerId).ToList();
			return customer;
		}

		/// <summary>
		/// 获取客户的分页数据
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="pageIndex">当前页</param>
		/// <param name="pageSize">页面大小，值为0时，表示不进行分页，查询所有有效示例的信息</param>
		/// <param name="sortName">排序字段名，默认值为RowIndex，客户名称：CustomerName；客户编号：CustomerNo；行号：RowIndex</param>
		/// <param name="sortType">排序类型，默认值为ascending，ascending：升序，descending：降序</param>
		/// <param name="keyword">可根据客户名称、客户编号进行模糊查询</param>
		/// <returns></returns>
		public PagerResult<CustomerRecord> GetValidPagerCustomers(int pageIndex, int pageSize, string sortName = "RowIndex", string sortType = Constant.SortAsc, string keyword = "")
		{
			var result = new PagerResult<CustomerRecord>();
			//查询客户分页数据
			var query = from customer in _customerRepository.Table
						where (string.IsNullOrEmpty(keyword) || customer.CustomerName.Contains(keyword) || customer.CustomerNo.Contains(keyword))
						&& customer.IsDelete == false
						select new CustomerRecord()
						{
							CustomerId = customer.CustomerId,
							CustomerName = customer.CustomerName,
							CustomerNo = customer.CustomerNo,
							CustomerLevel = customer.CustomerLevel,
							CustomerAddress = customer.CustomerAddress,
							CreateDate = customer.CreateDate,
							RowIndex = customer.RowIndex
						};
			//排序设置，默认以行号排序
			switch (sortName)
			{
				case "CustomerName":
					query = (sortType.ToLower() == Constant.SortAsc) ? query.OrderBy(p => p.CustomerName) : query.OrderByDescending(p => p.CustomerName);
					break;
				case "CustomerNo":
					query = (sortType.ToLower() == Constant.SortAsc) ? query.OrderBy(p => p.CustomerName) : query.OrderByDescending(p => p.CustomerName);
					break;
				default:
					query = (string.IsNullOrWhiteSpace(sortType) || sortType.ToLower() == Constant.SortAsc) ? query.OrderBy(p => p.RowIndex) : query.OrderByDescending(p => p.RowIndex);
					break;
			}
			return query.ToPagerResult<CustomerRecord>(pageIndex, pageSize);
		}

		/// <summary>
		/// 获取客户最大行号
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <returns></returns>
		private int GetCustomerMaxRowIndex()
		{
			int maxRowIndex = 10;
			if (_customerRepository.Table.Any(c => c.IsDelete == false))
			{
				maxRowIndex = _customerRepository.Table.Where(c => c.IsDelete == false).Max(c => c.RowIndex);
				maxRowIndex = maxRowIndex + 10;
			}
			return maxRowIndex;
		}
	}
}
