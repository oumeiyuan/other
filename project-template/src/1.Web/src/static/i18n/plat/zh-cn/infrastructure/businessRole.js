export default {
	businessRole: {
		//oper		

		//model
        roleName: "角色名称",
        categoryName: "角色分类",
		description: "角色描述",

		//msg		
		addRoleTitle: "新增角色",
		editRoleTitle: "修改角色",
		addRoleSuccess: "新增角色成功",
		editRoleSuccess: "修改角色成功",
		delRoleSuccess: "删除角色成功",
        roleNameNotBeEmpty: "角色名称不能为空",
        selectCategoryPlease: "请选择角色分类",

		search: "按名称进行搜索",

		//data		

		//code
		code: {
            121006: "新增失败，找不到角色分类,可能角色分类已被移除",
            121007: "新增失败，已存在一个相同的角色名称",
            121008: "修改失败，找不到可修改的角色",
            121009: "修改失败，已存在一个相同的角色名称",
            121010: "移除失败,找不到可移除的角色",
            121011: "移除失败,系统角色不可以移除",
            121012: "移除失败,角色已被引用"
		}
	}
}