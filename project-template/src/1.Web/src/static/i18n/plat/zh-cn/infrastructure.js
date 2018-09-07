import user from "./infrastructure/user.js";
import businessRoleCategory from "./infrastructure/businessRoleCategory.js";
import businessRole from "./infrastructure/businessRole.js";
import businessEntryRole from "./infrastructure/businessEntryRole.js";
import structure from "./infrastructure/structure.js";
import position from "./infrastructure/position.js";
import employee from "./infrastructure/employee.js";
import permission from "./infrastructure/permission.js";


export default {
	...user,
	...businessRoleCategory,
	...businessRole,
	...businessEntryRole,
	...structure,
	...position,
	...employee,
	...permission
}