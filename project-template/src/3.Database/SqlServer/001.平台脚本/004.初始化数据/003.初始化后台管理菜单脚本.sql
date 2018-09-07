
----TSys_Menu-- 菜单----------------------------
INSERT INTO TSys_AdminMenu 
	(MenuId,MenuName,MenuNo,MenuPath,ParentMenuId,IconPath,Enabled,RowIndex,Remark,CreateBy,CreateDate,LastEditBy,LastEditDate)
	SELECT MenuId,MenuName,MenuNo,MenuPath,ParentMenuId,IconPath,Enabled,RowIndex,Remark,CreateBy,CreateDate,LastEditBy,LastEditDate 
	FROM 
	(
		SELECT '' AS MenuId,'' AS MenuName,'' AS MenuNo,'' AS MenuPath,'' AS ParentMenuId,'' AS IconPath,'' AS Enabled,'' AS RowIndex,'' AS Remark,'' AS CreateBy,'' AS CreateDate,'' AS LastEditBy,'' AS LastEditDate WHERE 1=2
		UNION SELECT 'A_1',N'后台管理',N'03',N'/plat/admin.html#/',NULL,N'icon-backstage','1','40',N'后台管理','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_2',N'系统配置',N'03.01',N'','A_1',N'','1','10',N'系统配置','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_3',N'系统注册',N'03.01.01',N'/plat/admin.html#/register','A_2',N'','1','10',N'系统注册','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_4',N'客户端管理',N'03.01.02',N'/plat/admin.html#/client','A_2',N'','1','20',N'客户端管理','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_5',N'系统设置',N'03.01.03',N'/plat/admin.html#/config','A_2',N'','1','20',N'系统设置','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_6',N'菜单管理',N'03.01.04',N'/plat/admin.html#/menu','A_2',N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_15',N'基础配置',N'03.02',N'','A_1',N'','1','15',N'基础配置','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_16',N'项目状态',N'03.02.01',N'/plat/admin.html#/projectStatus','A_15',N'','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_7',N'维护管理',N'03.03',N'','A_1',N'','1','20',N'维护管理','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_8',N'登录日志',N'03.03.01',N'/plat/admin.html#/log/login','A_7',N'','1','10',N'日志查询','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_9',N'访问日志',N'03.03.02',N'/plat/admin.html#/log/access','A_7',N'','1','20',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_10',N'操作日志',N'03.03.03',N'/plat/admin.html#/log/operate','A_7',N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_11',N'异常日志',N'03.03.04',N'/plat/admin.html#/log/exception','A_7',N'','1','40',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_12',N'通知中心',N'03.04',N'','A_1',N'','1','30',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_13',N'通知类别',N'03.04.01',N'/plat/admin.html#/msgType?mode=0','A_12',N'','1','10',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()

		UNION SELECT 'A_14',N'事项类别',N'03.04.02',N'/plat/admin.html#/msgType?mode=1','A_12',N'','1','20',N'','sapiadmin',GETDATE(),'sapiadmin',GETDATE()		

	) data WHERE NOT EXISTS( SELECT 1 FROM dbo.TSys_AdminMenu t WHERE data.MenuId=ISNULL(t.MenuId,'')) ORDER BY [MenuId]
