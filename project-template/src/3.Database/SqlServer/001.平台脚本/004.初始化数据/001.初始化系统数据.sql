
--初始化数据
--1.客户端数据
INSERT INTO dbo.TSys_Client( ClientId ,ClientSecret ,Name ,Enabled ,RefreshTokenLifeTime ,CreateDate ,IsSystem)
SELECT 'MobileApp' , 'sapi@1234' , N'移动应用端' , 1 , 36000 , GETDATE() ,1 
UNION ALL
SELECT 'WebApp' , 'sapi@1234' , N'Web应用端' , 1 , 36000 , GETDATE() ,1 

--2.系统配置表
INSERT INTO dbo.TSys_Config( ConfigId ,ConfigName ,Value ,[Description] ,LastEditDate)
SELECT 'DefaultLanguage' , N'默认语言' , N'zh-cn' , NULL , GETDATE()  
UNION ALL
SELECT 'DefaultWebLayout' , N'默认布局' , N'default' , NULL , GETDATE() 
UNION ALL
SELECT 'DefaultWebTheme' , N'默认主题' , N'default' , NULL , GETDATE() 
UNION ALL
SELECT 'UserInitialPassword' , N'用户初始密码' , N'123456' , NULL , GETDATE()   
UNION ALL
SELECT 'ExportDataMaxCount', N'导出数据的最大数量',N'5000',N'用来限制导出数据的最大数量',GETDATE()
UNION ALL
SELECT 'QuickMenuSetting', N'首页快捷菜单',N'{"IsEnabled":false,"List":null}',null,GETDATE()
UNION ALL
SELECT 'DefaultFontSize', N'文字大小',N'default',NULL,GETDATE()
UNION ALL
SELECT 'LogoSettings',N'Logo图片设置',N'[{"FilePath":"Attachments\\Resource\\login_logo.png","FileSize":4314,"FileName":"login-logo","Extension":".png"},{"FilePath":"Attachments\\Resource\\main_logo.png","FileSize":4314,"FileName":"login-logo","Extension":".png"},{"FilePath":"Attachments\\Resource\\index_logo.png","FileSize":7235,"FileName":"main-logo","Extension":".png"},{"FilePath":"Attachments\\Resource\\login-body.jpg","FileSize":335075,"FileName":"login-body","Extension":".jpg"},{"FilePath":"Attachments\\Resource\\main-body-GaussianBlur.jpg","FileSize":335075,"FileName":"main-body","Extension":".jpg"},{"FilePath":"Attachments\\Resource\\loading.gif","FileSize":4919,"FileName":"sapi-loading-after","Extension":".gif"}]',NULL,GETDATE()
UNION ALL
SELECT 'Version',N'系统版本信息',N'{"Name":"平台","Version":"1.3.3","Description":"","Date":"2018-05-23","Author":"赛普爱德","Support":"","Dependencies":[{"Name":"Sapi","Version":"1.0.5"},{"Name":"Sapi.Data.EntityFramework","Version":"1.0.5"},{"Name":"Sapi.Redis","Version":"1.0.5"},{"Name":"Sapi.WebApi","Version":"1.0.5"}]}',N'用来查询系统版本信息',GETDATE()

--3.超级管理员账号，UserType 1：系统 2：职员 3：其他
INSERT INTO dbo.TSys_User( UserId , UserName , AliasName , HeadIconPath , UserType, CreateBy , CreateDate ,LastEditBy ,LastEditDate ,Enabled ,IsDelete ,RowIndex ,UsedById)
SELECT 'sapiadmin' , N'sapiadmin' ,N'超级管理员' ,  N'' , 1, 'sapiadmin' , GETDATE() , 'sapiadmin' , GETDATE() , 1 , 0 , 0 , NULL  

--4.用户配置表
INSERT INTO dbo.TSys_UserProfile( UserId ,WebTheme ,WebLayout ,[Language],[FontSize] ,LastEditDate)
SELECT 'sapiadmin' , N'default' , N'default' , N'zh-cn' ,N'default', GETDATE()

--5.用户身份认证表，密码：sapi@2017
INSERT INTO dbo.TSys_UserSecurity( UserId ,[Password] ,SecurityStamp ,LastPasswordChangedDate ,LastPasswordChangedBy ,Remark)
SELECT 'sapiadmin' , N'b077faefbdd0b7adc8bc0c9bfb08daf5' ,NULL , GETDATE() ,'sapiadmin' ,N'超管帐号，系统初始化时加入。' 

--6.初始化项目状态数据
INSERT INTO TBas_ProjectStatus(StatusId,StatusName,Remark,RowIndex,CreateBy,CreateByName,CreateDate,LastEditBy,LastEditByName,LastEditDate)
SELECT 'Decisioning','待决策','',10,'sapiadmin','sapiadmin',GETDATE(),'sapiadmin','sapiadmin',GETDATE()
UNION ALL
SELECT 'UnStarted','未开工','',20,'sapiadmin','sapiadmin',GETDATE(),'sapiadmin','sapiadmin',GETDATE()
UNION ALL
SELECT 'Constructing','在建未售','',30,'sapiadmin','sapiadmin',GETDATE(),'sapiadmin','sapiadmin',GETDATE()
UNION ALL
SELECT 'Selling','在建已售','',40,'sapiadmin','sapiadmin',GETDATE(),'sapiadmin','sapiadmin',GETDATE()
UNION ALL
SELECT 'Finished','已完结','',50,'sapiadmin','sapiadmin',GETDATE(),'sapiadmin','sapiadmin',GETDATE()
UNION ALL
SELECT 'Aborted','中止','',60,'sapiadmin','sapiadmin',GETDATE(),'sapiadmin','sapiadmin',GETDATE()

--7.系统架构表中初始化集团数据
INSERT INTO dbo.TSys_Structure 
(	
	StruId, StruName, FullName, StruNo,ParentStruId, StruType, CorpId, IconPath,DeptHeaderId, ChargeLeaderId,
	FunctionHigherId, RowIndex, Outline, IsLeaf, [Level],IsDelete, CreateBy, CreateDate, LastEditBy,LastEditDate
)
VALUES  
( 
	'TotalCompany',N'集团',N'集团','0001',NULL,0,'TotalCompany',NULL,NULL,NULL,
		NULL,10,'0001',1,1,0,'sapiadmin',GETDATE(),'sapiadmin',GETDATE()  
)

--8.添加通用角色信息
INSERT INTO dbo.TSys_Role( RoleId ,RoleName ,RoleNo ,Remark ,CreateDate ,CreateBy ,LastEditBy ,LastEditDate ,RowIndex ,IsSystem)
SELECT 'General' ,N'通用角色' ,N'' , N'用于控制每个用户均可以操作的通用菜单及其资源信息' ,GETDATE() , 'sapiadmin' , 'sapiadmin' , GETDATE() , 10 ,1







        