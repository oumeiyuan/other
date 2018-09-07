export default {
	businessRoleCategory: {
		//oper		

		//model
        categoryName: "分类名称",
		description: "描述",

		//msg		
		addCategoryTitle: "新增角色分类",
		editCategoryTitle: "修改角色分类",
		addCategorySuccess: "新增角色分类成功",
		editCategorySuccess: "修改角色分类成功",
		delCategorySuccess: "删除角色分类成功",
        categoryNameNotBeEmpty: "分类名称不能为空",

		search: "按名称进行搜索",

		//data		

		//code
		code: {
            121001: "新增失败，已存在一个相同的分类名称",
            121002: "修改失败，找不到可修改的角色分类",
            121003: "修改失败，已存在一个相同的分类名称",
            121004: "移除失败，找不到可移除的角色分类",
            121005: "移除失败，角色分类已被引用"
		}
	}
}