import building from "./base/building.js";
import land from "./base/land.js";
import projectType from "./base/projectType.js";
import projectPeriod from "./base/projectPeriod.js";
import formType from "./base/formType.js";
import professionalType from "./base/professionalType.js";


export default {
	...building,
	...land,
	...projectType,
    ...projectPeriod,
    ...formType,
    ...professionalType
}