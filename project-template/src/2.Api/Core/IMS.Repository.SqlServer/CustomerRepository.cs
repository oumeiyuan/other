using IMS.Models;
using IMS.Repositories;
using Sapi.Data;
using Sapi.Data.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMS.Repository.SqlServer
{
	/// <summary>
	/// 
	/// </summary>
	public class CustomerRepository : Repository<Customer>, ICustomerRepository
	{
		/// <summary>
		/// 构造函数
		/// </summary>
		/// <param name="unitOfWork"></param>
		public CustomerRepository(IUnitOfWork unitOfWork)
			: base(unitOfWork)
		{

		}
	}
}
