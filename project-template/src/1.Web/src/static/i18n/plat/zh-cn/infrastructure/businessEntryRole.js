export default {
	businessEntryRole: {
		//oper
		member: "成员",

		//model
        roleName: "角色名称",
		description: "角色描述",
		entry: "所属业务",
		categoryName: "角色分类",
        userName: "用户帐号",
		aliasName: "用户实名",


		//msg
		corpTitle: "所属公司",
		projectTitle: "所属项目",
		browseRoleTitle: "查看业务角色设置",
		chooseRoleTitle: "选择角色",
		setRoleTitle: "{roleName}角色成员",
		setUserTitle: "设置用户",
		

		handlePermission: "操作权限",
		setSuccess: "设置成功",
		chooseRoleSuccess: "选择角色成功",
		tabBasicInformation: "基本信息",
		selectOneWhenAdd: "请至少选择一个角色",

		tabIncludeUsers: "包含用户",
		selectedUserDesc: "已选用户：{userCount}人",
		moreThanUpperLimit: "已经达到100人上限",

		search: "按名称进行搜索",
		searchUser: "按用户帐号、用户实名进行搜索",

		//data		

		//code
		code: {
			121013: "初始化失败,找不到可初始化的角色",
			121014: "找不到可补充的业务,请填写正确的角色类型和业务Id",
			121015: "设置失败,找不到可设置的角色",
			121016: "移除失败,找不到可移除的角色成员"
		}
	}
}