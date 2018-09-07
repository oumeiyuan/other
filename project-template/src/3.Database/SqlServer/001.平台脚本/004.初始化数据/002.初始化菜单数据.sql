

----TSys_Menu-- 菜单----------------------------
INSERT INTO TSys_Menu 
	(MenuId,ClientId,MenuName,MenuNo,MenuPath,ParentMenuId,IconPath,Enabled,RowIndex,Remark,CreateBy,CreateDate,LastEditBy,LastEditDate)
	SELECT MenuId,ClientId,MenuName,MenuNo,MenuPath,ParentMenuId,IconPath,Enabled,RowIndex,Remark,CreateBy,CreateDate,LastEditBy,LastEditDate FROM (
	SELECT '' AS MenuId,'' AS ClientId,'' AS MenuName,'' AS MenuNo,'' AS MenuPath,'' AS ParentMenuId,'' AS IconPath,'' AS Enabled,'' AS RowIndex,'' AS Remark,'' AS CreateBy,'' AS CreateDate,'' AS LastEditBy,'' AS LastEditDate WHERE 1=2
	UNION SELECT '1','WebApp',N'个人工作',N'01',N'/plat/notification.html#/',NULL,N'icon-pwork','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '2','WebApp',N'我的消息',N'01.01',N'/plat/notification.html#/center','1',N'','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '3','WebApp',N'系统管理',N'02',N'/plat/infrastructure.html#/',NULL,N'icon-sys','1','40',N'系统管理','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '4','WebApp',N'用户管理',N'02.01',N'/plat/infrastructure.html#/user','3',N'','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '5','WebApp',N'权限管理',N'02.02',N'/plat/infrastructure.html#/permission','3',N'','1','20',N'权限管理','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '6','WebApp',N'企业架构',N'02.03',N'/plat/infrastructure.html#/structure','3',N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '7','WebApp',N'企业职位',N'02.04',N'/plat/infrastructure.html#/position','3',N'','1','40',N'企业职位','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '9','WebApp',N'企业员工',N'02.06',N'/plat/infrastructure.html#/employee','3',N'','1','60',N'企业员工','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '13','WebApp',N'项目数据',N'04',N'/plat/base.html#/',NULL,N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '15','WebApp',N'项目结构',N'',N'/plat/base.html#/building','13',N'','1','20',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '16','WebApp',N'地块信息',N'04.01',N'/plat/base.html#/land','13',N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '17','WebApp',N'项目类别',N'04.02',N'/plat/base.html#/projectType','13',N'','1','40',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '18','WebApp',N'项目阶段',N'04.03',N'/plat/base.html#/projectperiod','13',N'','1','50',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '19','WebApp',N'物业形态',N'04.04',N'/plat/base.html#/formType','13',N'','1','60',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '21','WebApp',N'供方数据',N'21',N'/plat/supplier.html#/',NULL,N'','1','32',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '22','WebApp',N'供方基础分类',N'',N'/plat/supplier.html#/baseclass','21',N'','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '23','WebApp',N'供方分类',N'',N'/plat/supplier.html#/class','21',N'','1','20',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '24','WebApp',N'供方一览',N'',N'/plat/supplier.html#/manage','21',N'','1','40',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '31','WebApp',N'公司角色',N'',N'','3',N'','1','70',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '32','WebApp',N'角色成员',N'',N'/plat/infrastructure.html#/businessEntryRole?type=1','31',N'','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '33','WebApp',N'基础角色',N'',N'/plat/infrastructure.html#/businessRole?type=1','31',N'','1','20',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

	UNION SELECT '34','WebApp',N'角色分类',N'',N'/plat/infrastructure.html#/businessRoleCategory?type=1','31',N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

) data WHERE NOT EXISTS( SELECT 1 FROM TSys_Menu t WHERE data.MenuId=ISNULL(t.MenuId,'')) ORDER BY [MenuId]

------TSys_MenuResource 菜单资源-------------------------
INSERT INTO TSys_MenuResource 
	(ResourceId,MenuId,ResourceCode,ResourceName,Remark,RowIndex)
	SELECT ResourceId,MenuId,ResourceCode,ResourceName,Remark,RowIndex FROM (
	SELECT '' AS ResourceId,'' AS MenuId,'' AS ResourceCode,'' AS ResourceName,'' AS Remark,'' AS RowIndex WHERE 1=2
	UNION SELECT '1_View','1','View',N'浏览',N'','10'

	UNION SELECT '2_View','2','View',N'浏览',N'','10'

	UNION SELECT '3_View','3','View',N'浏览',N'','10'

	UNION SELECT '4_View','4','View',N'浏览',N'','10'

	UNION SELECT '4_Add','4','Add',N'新增',N'','20'

	UNION SELECT '4_Edit','4','Edit',N'修改',N'','30'

	UNION SELECT '4_Delete','4','Delete',N'删除',N'','40'

	UNION SELECT '4_Import','4','Import',N'导入',N'','50'

	UNION SELECT '4_Export','4','Export',N'导出',N'','60'

	UNION SELECT '4_Reset','4','Reset',N'重置',N'','250'

	UNION SELECT '5_View','5','View',N'浏览',N'','10'

	UNION SELECT '5_Add','5','Add',N'新增',N'','20'

	UNION SELECT '5_Edit','5','Edit',N'修改',N'','30'

	UNION SELECT '5_Delete','5','Delete',N'删除',N'','40'

	UNION SELECT '5_Setting','5','Setting',N'设置',N'','100'

	UNION SELECT '6_View','6','View',N'浏览',N'','10'

	UNION SELECT '6_Add','6','Add',N'新增',N'','20'

	UNION SELECT '6_Edit','6','Edit',N'修改',N'','30'

	UNION SELECT '6_Delete','6','Delete',N'删除',N'','40'

	UNION SELECT '6_Import','6','Import',N'导入',N'','50'

	UNION SELECT '6_Export','6','Export',N'导出',N'','60'

	UNION SELECT '7_View','7','View',N'浏览',N'','10'

	UNION SELECT '7_Add','7','Add',N'新增',N'','20'

	UNION SELECT '7_Edit','7','Edit',N'修改',N'','30'

	UNION SELECT '7_Delete','7','Delete',N'删除',N'','40'

	UNION SELECT '7_Import','7','Import',N'导入',N'','50'

	UNION SELECT '7_Export','7','Export',N'导出',N'','60'

	UNION SELECT '9_View','9','View',N'浏览',N'','10'

	UNION SELECT '9_Add','9','Add',N'新增',N'','20'

	UNION SELECT '9_Edit','9','Edit',N'修改',N'','30'

	UNION SELECT '9_Delete','9','Delete',N'删除',N'','40'

	UNION SELECT '9_Import','9','Import',N'导入',N'','50'

	UNION SELECT '9_Export','9','Export',N'导出',N'','60'

	UNION SELECT '13_View','13','View',N'浏览',N'','0'

	UNION SELECT '15_View','15','View',N'浏览',N'','0'

	UNION SELECT '15_Add','15','Add',N'新增',N'','20'

	UNION SELECT '15_Edit','15','Edit',N'修改',N'','30'

	UNION SELECT '15_Delete','15','Delete',N'删除',N'','40'

	UNION SELECT '16_View','16','View',N'浏览',N'','0'

	UNION SELECT '16_Add','16','Add',N'新增',N'','20'

	UNION SELECT '16_Edit','16','Edit',N'修改',N'','30'

	UNION SELECT '16_Delete','16','Delete',N'删除',N'','40'

	UNION SELECT '17_View','17','View',N'浏览',N'','0'

	UNION SELECT '17_Add','17','Add',N'新增',N'','20'

	UNION SELECT '17_Edit','17','Edit',N'修改',N'','30'

	UNION SELECT '17_Delete','17','Delete',N'删除',N'','40'

	UNION SELECT '18_View','18','View',N'浏览',N'','0'

	UNION SELECT '18_Add','18','Add',N'新增',N'','20'

	UNION SELECT '18_Edit','18','Edit',N'修改',N'','30'

	UNION SELECT '18_Delete','18','Delete',N'删除',N'','40'

	UNION SELECT '19_View','19','View',N'浏览',N'','0'

	UNION SELECT '19_Add','19','Add',N'新增',N'','20'

	UNION SELECT '19_Edit','19','Edit',N'修改',N'','30'

	UNION SELECT '19_Delete','19','Delete',N'删除',N'','40'

	UNION SELECT '21_View','21','View',N'浏览',N'','0'

	UNION SELECT '22_View','22','View',N'浏览',N'','0'

	UNION SELECT '22_Edit','22','Edit',N'修改',N'','30'

	UNION SELECT '23_View','23','View',N'浏览',N'','0'

	UNION SELECT '23_Add','23','Add',N'新增',N'','20'

	UNION SELECT '23_Edit','23','Edit',N'修改',N'','30'

	UNION SELECT '23_Delete','23','Delete',N'删除',N'','40'

	UNION SELECT '24_View','24','View',N'浏览',N'','0'

	UNION SELECT '24_Add','24','Add',N'新增',N'','20'

	UNION SELECT '24_Edit','24','Edit',N'修改',N'','30'

	UNION SELECT '24_Delete','24','Delete',N'删除',N'','40'

	UNION SELECT '24_Import','24','Import',N'导入',N'','50'

	UNION SELECT '31_View','31','View',N'浏览',N'','0'

	UNION SELECT '32_View','32','View',N'浏览',N'','0'

	UNION SELECT '32_Add','32','Add',N'新增',N'','20'

	UNION SELECT '32_Delete','32','Delete',N'删除',N'','40'

	UNION SELECT '32_Setting','32','Setting',N'设置',N'','100'

	UNION SELECT '33_View','33','View',N'浏览',N'','0'

	UNION SELECT '33_Add','33','Add',N'新增',N'','20'

	UNION SELECT '33_Edit','33','Edit',N'修改',N'','30'

	UNION SELECT '33_Delete','33','Delete',N'删除',N'','40'

	UNION SELECT '34_View','34','View',N'浏览',N'','0'

	UNION SELECT '34_Add','34','Add',N'新增',N'','20'

	UNION SELECT '34_Edit','34','Edit',N'修改',N'','30'

	UNION SELECT '34_Delete','34','Delete',N'删除',N'','40'

) data
	WHERE NOT EXISTS(
	SELECT 1 FROM TSys_MenuResource t
	WHERE data.ResourceId=ISNULL(t.ResourceId,'')
)
	ORDER BY [MenuId],[RowIndex]


------TSys_MenuResourcePath 资源路径-------------------------
INSERT INTO TSys_MenuResourcePath 
	(ResourceId,Method,Path,RowIndex)
	SELECT ResourceId,Method,Path,RowIndex FROM (
	SELECT '' AS ResourceId,'' AS Method,'' AS Path,'' AS RowIndex WHERE 1=2
	UNION SELECT '4_View','GET','api/plat/users/{userId}','10'

	UNION SELECT '4_View','GET','api/plat/users','20'

	UNION SELECT '4_Add','POST','api/plat/users','10'

	UNION SELECT '4_Edit','PUT','api/plat/users','10'

	UNION SELECT '4_Delete','DELETE','api/plat/users/{userId}','10'

	UNION SELECT '4_Delete','DELETE','api/plat/users','20'

	UNION SELECT '4_Import','POST','api/plat/users/import','10'

	UNION SELECT '4_Export','GET','api/plat/users/export','10'

	UNION SELECT '4_Reset','PUT','api/plat/users/{userId}/password','10'

	UNION SELECT '5_Add','POST','api/plat/roles','10'

	UNION SELECT '5_Edit','PUT','api/plat/roles','10'

	UNION SELECT '5_Delete','DELETE','api/plat/roles/{roleId}','10'

	UNION SELECT '5_Delete','DELETE','api/plat/roles','20'

	UNION SELECT '5_Setting','PUT','api/plat/roles/users','10'

	UNION SELECT '5_Setting','DELETE','api/plat/roles/users','20'

	UNION SELECT '5_Setting','PUT','api/plat/roles/{roleId}/resources','30'
	
	UNION SELECT '6_View','GET','api/plat/structures','10'

	UNION SELECT '6_View','GET','api/plat/stations','20'
				  
	UNION SELECT '6_Add','POST','api/plat/structures','10'

	UNION SELECT '6_Add','POST','api/plat/stations','20'
				  
	UNION SELECT '6_Edit','PUT','api/plat/structures','10'

	UNION SELECT '6_Edit','PUT','api/plat/stations','20'
				  
	UNION SELECT '6_Delete','DELETE','api/plat/structures/{struId}','10'

	UNION SELECT '6_Delete','DELETE','api/plat/stations/{stationId}','20'

	UNION SELECT '6_Delete','DELETE','api/plat/stations','30'
				  
	UNION SELECT '6_Import','POST','api/plat/structures/import','10'

	UNION SELECT '6_Import','POST','api/plat/stations/import','20'
				  
	UNION SELECT '6_Export','GET','api/plat/structures/export','10'
				  			  
	UNION SELECT '6_Export','GET','api/plat/stations/export','20'

	UNION SELECT '7_View','GET','api/plat/positions','10'

	UNION SELECT '7_Add','POST','api/plat/positions','10'

	UNION SELECT '7_Edit','PUT','api/plat/positions','10'

	UNION SELECT '7_Delete','DELETE','api/plat/positions/{positionId}','10'

	UNION SELECT '7_Delete','DELETE','api/plat/positions','20'
	
	UNION SELECT '7_Import','POST','api/plat/positions/import','10'

	UNION SELECT '7_Export','GET','api/plat/positions/export','10'

	UNION SELECT '9_View','GET','api/plat/employees','10'

	UNION SELECT '9_Add','POST','api/plat/employees','10'

	UNION SELECT '9_Edit','PUT','api/plat/employees','10'

	UNION SELECT '9_Delete','DELETE','api/plat/employees/{employeeId}','10'

	UNION SELECT '9_Delete','DELETE','api/plat/employees','20'

	UNION SELECT '9_Import','POST','api/plat/employees/import','10'

	UNION SELECT '9_Export','GET','api/plat/employees/export','10'

	UNION SELECT '15_Add','POST','api/plat/projects','20'

	UNION SELECT '15_Edit','PUT','api/plat/projects','20'

	UNION SELECT '15_Delete','DELETE','api/plat/projects/{projectId}','20'

	UNION SELECT '15_Add','POST','api/plat/buildings','10'

	UNION SELECT '15_Edit','PUT','api/plat/buildings','10'

	UNION SELECT '15_Delete','DELETE','api/plat/buildings','10'

	UNION SELECT '16_Add','POST','api/plat/lands','10'

	UNION SELECT '16_Edit','PUT','api/plat/lands','10'

	UNION SELECT '16_Delete','DELETE','api/plat/lands/{landId}','10'

	UNION SELECT '17_Add','POST','api/plat/projectTypes','10'

	UNION SELECT '17_Edit','PUT','api/plat/projectTypes','10'

	UNION SELECT '17_Delete','DELETE','api/plat/projectTypes','10'

	UNION SELECT '18_Add','POST','api/plat/projectPeriods','10'

	UNION SELECT '18_Edit','PUT','api/plat/projectPeriods','10'

	UNION SELECT '18_Delete','DELETE','api/plat/projectPeriods','10'

	UNION SELECT '19_Add','POST','api/plat/formTypes','10'

	UNION SELECT '19_Edit','PUT','api/plat/formTypes','10'

	UNION SELECT '19_Delete','DELETE','api/plat/formTypes/{typeId}','10'

	UNION SELECT '22_Edit','PUT','api/plat/supplierBaseClasses','10'

	UNION SELECT '23_Add','POST','api/plat/supplierClasses','10'

	UNION SELECT '23_Edit','PUT','api/plat/supplierClasses','10'

	UNION SELECT '23_Delete','DELETE','api/plat/supplierClasses/{classId}','10'

	UNION SELECT '24_Add','POST','api/plat/suppliers','10'

	UNION SELECT '24_Edit','PUT','api/plat/suppliers','10'

	UNION SELECT '24_Delete','DELETE','api/plat/suppliers','10'

	UNION SELECT '24_Import','POST','api/plat/suppliers/import','10'

	UNION SELECT '32_Add','POST','api/plat/businessEntryRoles','10'

	UNION SELECT '32_Delete','DELETE','api/plat/businessEntryRoles/users','10'

	UNION SELECT '32_Setting','PUT','api/plat/businessEntryRoles/users','10'

	UNION SELECT '33_Add','POST','api/plat/businessRoles/roles','10'

	UNION SELECT '33_Edit','PUT','api/plat/businessRoles/roles','10'

	UNION SELECT '33_Delete','DELETE','api/plat/businessRoles/roles/{roleId}','10'

	UNION SELECT '33_Delete','DELETE','api/plat/businessRoles/roles','20'

	UNION SELECT '34_Add','POST','api/plat/businessRoles/categories','10'

	UNION SELECT '34_Edit','PUT','api/plat/businessRoles/categories','10'

	UNION SELECT '34_Delete','DELETE','api/plat/businessRoles/categories/{categoryId}','10'

	UNION SELECT '34_Delete','DELETE','api/plat/businessRoles/categories','20'

) data
	WHERE NOT EXISTS(
	SELECT 1 FROM TSys_MenuResourcePath t
	WHERE data.ResourceId=ISNULL(t.ResourceId,'') AND data.Method=ISNULL(t.Method,'') AND data.Path=ISNULL(t.Path,''))
	ORDER BY [ResourceId],[RowIndex]