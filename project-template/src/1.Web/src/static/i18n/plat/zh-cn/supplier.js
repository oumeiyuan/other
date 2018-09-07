import supplierBaseClass from "./supplier/baseclass.js";
import supplierClass from "./supplier/class.js";
import supplierManage from "./supplier/manage.js";


export default {
	...supplierBaseClass,
	...supplierClass,
	...supplierManage
}