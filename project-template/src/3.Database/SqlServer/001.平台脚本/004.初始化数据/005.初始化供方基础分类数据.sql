--供方基础分类表中初始化基础分类数据
INSERT INTO dbo.TSup_SupplierBaseClass
(	
	ClassId, ClassName, RowIndex, IsDelete, Remark, CreateBy, CreateByName, CreateDate, LastEditBy, LastEditByName, LastEditDate
)
SELECT NEWID() , '施工' , 10 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()
UNION ALL
SELECT NEWID() , '供货' , 20 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()
UNION ALL
SELECT NEWID() , '设计' , 30 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()
UNION ALL
SELECT NEWID() , '监理' , 40 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()
UNION ALL
SELECT NEWID() , '咨询' , 50 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()
UNION ALL
SELECT NEWID() , '市场' , 60 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()
UNION ALL
SELECT NEWID() , '其他' , 70 , 0 , '',  '超级管理员' , 'sapiadmin', GETDATE(), '超级管理员' , 'sapiadmin', GETDATE()