using IDPlat.Models;
using IDPlat.Services;
using IMS.Core.ViewModels;
using IMS.Models;
using IMS.Services;
using Newtonsoft.Json;
using Sapi.Utility;
using Sapi.WebApi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace IMS.Core.Controllers
{
	/// <summary>
	/// 客户控制器
	/// </summary>
	[RoutePrefix("api/ims/customers")]
	public class CustomerController : DefaultApiController
	{
		private readonly ICustomerService _customerService;

		/// <summary>
		/// 构造函数
		/// </summary>
		/// <param name="customerService"></param>
		public CustomerController(ICustomerService customerService)
		{
			_customerService = customerService;
		}

		/// <summary>
		/// 新增客户
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customerModel">客户模型</param>
		/// <returns></returns>
		[HttpPost, Route("")]
		[ValidateModelFilter]
		[ModuleAuthorize]
		public ResponseResult AddCustomer(CustomerCreateViewModel customerModel)
		{
			var result = new ResponseResult(PromptCode.SUCCESS, "新增客户成功。");
			//模型转换
			var currentTime = DateTime.Now;
			var customer = new Customer()
			{
				CustomerId = Guid.NewGuid().ToString(),
				CustomerName = customerModel.CustomerName,
				CustomerNo = customerModel.CustomerNo,
				CustomerLevel = customerModel.CustomerLevel,
 				CustomerAddress = customerModel.CustomerAddress, 				 
				Description = customerModel.Description,
				IsDelete = false,
				CreateBy = Session.UserId,
				CreateByName = Session.AliasName,
				CreateDate = currentTime,
				LastEditBy = Session.UserId,
				LastEditByName = Session.AliasName,
				LastEditDate = currentTime
			};
			//转换联系人信息
			if (customerModel.Contacters != null && customerModel.Contacters.Count > 0)
			{
				var rowIndex = 10;
				foreach (var contacter in customerModel.Contacters)
				{
					customer.Contacters.Add(new Contacter()
					{
						ContacterId = Guid.NewGuid().ToString(),
						CustomerId = customer.CustomerId,
						ContacterName = contacter.ContacterName,
						Sex = contacter.Sex,
						MobileTelephone = contacter.MobileTelephone,
						Remark = contacter.Remark,
						RowIndex = rowIndex
					});
					rowIndex += 10;
				}
			}
			if (!_customerService.AddCustomer(customer))
			{
				result.Code = _customerService.Message.Code;
				result.Message = _customerService.Message.Content;
				return result;
			}
			//记录操作成功日志
			Logger.Information(Request, "新增客户成功。", JsonConvert.SerializeObject(customerModel));
			return result;
		}

		/// <summary>
		/// 修改客户
		/// 作者；杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customerModel">客户模型</param>
		/// <returns></returns>
		[HttpPut, Route("")]
		[ValidateModelFilter]
		[ModuleAuthorize]
		public ResponseResult EditCustomer(CustomerEditViewModel customerModel)
		{
			var result = new ResponseResult(PromptCode.SUCCESS, "修改客户成功。");
			//模型转换
			var customer = new Customer()
			{
				CustomerId = customerModel.CustomerId,
				CustomerName = customerModel.CustomerName,
				CustomerNo = customerModel.CustomerNo,
				CustomerLevel = customerModel.CustomerLevel,
				CustomerAddress = customerModel.CustomerAddress,
				Description = customerModel.Description,
				RowIndex = customerModel.RowIndex,
				LastEditBy = Session.UserId,
				LastEditByName = Session.AliasName,
				LastEditDate = DateTime.Now
			};
			
			//转换联系人信息
			if (customerModel.Contacters != null && customerModel.Contacters.Count > 0)
			{
				var rowIndex = 10;
				foreach (var contacter in customerModel.Contacters)
				{
					customer.Contacters.Add(new Contacter()
					{
						ContacterId = Guid.NewGuid().ToString(),
						CustomerId = customer.CustomerId,
						ContacterName = contacter.ContacterName,
						Sex = contacter.Sex,
						MobileTelephone = contacter.MobileTelephone,
						Remark = contacter.Remark,
						RowIndex = rowIndex
					});
					rowIndex += 10;
				}
			}

			if (!_customerService.EditCustomer(customer))
			{
				result.Code = _customerService.Message.Code;
				result.Message = _customerService.Message.Content;
				return result;
			}
			//记录操作成功日志
			Logger.Information(Request, "修改客户成功。", JsonConvert.SerializeObject(customerModel));
			return result;
		}

		/// <summary>
		/// 移除客户
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customerId">客户Id</param>
		/// <returns></returns>
		[HttpDelete, Route("{customerId}")]
		[ModuleAuthorize]
		public ResponseResult RemoveCustomer(string customerId)
		{
			var result = new ResponseResult(PromptCode.SUCCESS, "移除客户成功。");
			if (string.IsNullOrWhiteSpace(customerId))
			{
				result.Code = PromptCode.ERROR;
				result.Message = "移除失败，参数customerId为空。";
				return result;
			}
			if (!_customerService.RemoveCustomer(customerId))
			{
				result.Code = _customerService.Message.Code;
				result.Message = _customerService.Message.Content;
				return result;
			}
			//记录操作日志成功
			Logger.Information(Request, "移除客户成功。", customerId);
			return result;
		}

		/// <summary>
		/// 批量移除客户
		/// 作者：杨俊
		/// 日期：2017-12-05
		/// </summary>
		/// <param name="customerIds">客户Ids</param>
		/// <returns></returns>
		[HttpDelete, Route("")]
		[ModuleAuthorize]
		public ResponseResult RemoveCustomer(string[] customerIds)
		{
			var result = new ResponseResult(Sapi.Utility.PromptCode.SUCCESS, "批量移除客户成功。");
			if (customerIds == null || customerIds.Length == 0)
			{
				result.Code = Sapi.Utility.PromptCode.ERROR;
				result.Message = "移除失败，参数customerIds异常。";
				return result;
			}
			if (!_customerService.RemoveCustomer(customerIds))
			{
				result.Code = _customerService.Message.Code;
				result.Message = _customerService.Message.Content;
				return result;
			}
			//记录操作成功日志
			Logger.Information(Request, "批量移除客户成功。", JsonConvert.SerializeObject(customerIds));
			return result;
		}

		/// <summary>
		/// 根据客户Id获取客户信息
		/// 作者：杨俊
		/// 日期：2017-09-29
		/// </summary>
		/// <param name="customerId">客户Id</param>
		/// <returns></returns>
		[HttpGet, Route("{customerId}")]
		public ResponseResult<CustomerViewModel> GetCustomer(string customerId)
		{
			var result = new ResponseResult<CustomerViewModel>(PromptCode.SUCCESS, "获取数据成功。");
			if (string.IsNullOrWhiteSpace(customerId))
			{
				result.Code = Sapi.Utility.PromptCode.ERROR;
				result.Message = "获取数据失败，参数customerId为空。";
				return result;
			}
			var customer = _customerService.GetCustomer(customerId);
			if (customer == null)
			{
				result.Code = PromptCode.ERROR;
				result.Message = "获取数据失败，返回结果为空。";
				return result;
			}
		
			var customerModel = new CustomerViewModel()
			{
				CustomerId = customer.CustomerId,
				CustomerName = customer.CustomerName,
				CustomerNo = customer.CustomerNo,
				CustomerLevel = customer.CustomerLevel,
				CustomerAddress = customer.CustomerAddress,
				Description = customer.Description,
				RowIndex = customer.RowIndex,
				CreateBy = customer.CreateBy,
				CreateByName = customer.CreateByName,
				CreateDate = customer.CreateDate,
				LastEditBy = customer.LastEditBy,
				LastEditByName = customer.LastEditByName,
				LastEditDate = customer.LastEditDate
			};
			if (customer.Contacters != null && customer.Contacters.Count > 0)
			{
				foreach (var contacter in customer.Contacters)
				{
					customerModel.Contacters.Add(new ContacterViewModel()
					{
						ContacterId = contacter.ContacterId,
						CustomerId = customerModel.CustomerId,
						ContacterName = contacter.ContacterName,
						Sex = contacter.Sex,
						MobileTelephone = contacter.MobileTelephone,
						Remark = contacter.Remark,
						RowIndex = contacter.RowIndex
					});
				}
			}
			result.Data = customerModel;
			return result;
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
		[HttpGet, Route("")]
		public ResponseResult<PagerResult<CustomerRecord>> GetValidPagerCustomers(int pageIndex, int pageSize, string sortName = "RowIndex", string sortType = Constant.SortAsc, string keyword = "")
		{
			var result = new ResponseResult<PagerResult<CustomerRecord>>(PromptCode.SUCCESS, "获取数据成功。");
			var data = _customerService.GetValidPagerCustomers(pageIndex, pageSize, sortName, sortType, keyword);
			if (data == null)
			{
				result.Code = PromptCode.ERROR;
				result.Message = "获取数据失败，返回结果为空。";
				return result;
			}
			result.Data = data;
			return result;
		}
	
	}
}
