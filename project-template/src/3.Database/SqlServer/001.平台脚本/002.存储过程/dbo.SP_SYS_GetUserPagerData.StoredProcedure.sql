/****** Object:  StoredProcedure [dbo].[SP_SYS_GetUserPagerData]    Script Date: 2018/5/18 22:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:	    杨俊
-- Create date: 2018-05-18
-- Description:	获取指定架构下有效用户的分页数据（不包含系统用户）
-- =============================================
CREATE PROCEDURE [dbo].[SP_SYS_GetUserPagerData]
	@StruId VARCHAR(36),					--架构Id
	@StruType INT,							--架构类型，0：公司，1：部门
	@WithChild BIT = 1,						--是否带有子级
	@WhereClip NVARCHAR(2000),				--条件(不含WHERE关键字)
	@OrderByClip VARCHAR(200),				--排序列(不含ORDER BY关键字)
	@PageIndex INT = 1,						--当前页
	@PageSize INT = 20,						--页面大小
	@Total INT = 0 OUTPUT,					--总记录数
	@FinalPageIndex INT = 0 OUTPUT			--总页数
AS
BEGIN
	DECLARE @Sql NVARCHAR(MAX),				--获取人员的语句
			@SkipRows INT = 0				--需要跳过的行数	

	CREATE TABLE #Stru						--企业架构临时表
	(
		StruId VARCHAR(36),
		StruName NVARCHAR(100),
		ParentStruId VARCHAR(36),
		CorpId VARCHAR(36),
		Outline VARCHAR(100)		
	)

	CREATE TABLE #Personnel
	(
		Idx INT IDENTITY(1,1),
		UserId VARCHAR(36),
		UserName NVARCHAR(100),
		AliasName NVARCHAR(100),
		HeadIconPath NVARCHAR(1000),
		EmployeeId VARCHAR(36),
		EmployeeName NVARCHAR(100),
		StationId VARCHAR(36),
		StationName NVARCHAR(50),
		DeptId VARCHAR(36),
		DeptName NVARCHAR(100),
		CorpId VARCHAR(36),
		CorpName NVARCHAR(100),
		PositionId VARCHAR(36),
		PositionName NVARCHAR(200)
	)

	--1.获取有效的企业架构数据放入临时表#Stru
	--当@WithChild=0，表示不带子级，此时架构类型如果为公司，则要获取直属于该公司的部门；如果为部门，则不获取其子级部门
	;WITH CTE AS 
				(
					SELECT StruId,StruName,ParentStruId,CorpId,Outline
					FROM dbo.TSys_Structure 
					WHERE IsDelete = 0 AND StruId = @StruId AND StruType = @StruType
					UNION ALL
					SELECT A.StruId,A.StruName,A.ParentStruId,A.CorpId,A.Outline
					FROM dbo.TSys_Structure A
					INNER JOIN CTE AS B ON A.ParentStruId = B.StruId
					WHERE A.IsDelete = 0  AND (@WithChild = 1 OR (@StruType = 0 AND StruType = 1))
				)
	INSERT INTO #Stru
	SELECT StruId,StruName,ParentStruId,CorpId,Outline
	FROM CTE
	
	--2.拼接语句
	DECLARE @TopCount INT,@PreSql NVARCHAR(MAX),@LastSql NVARCHAR(MAX)
	SELECT @TopCount=@PageSize*@PageIndex
	SET @PreSql = 'INSERT INTO #Personnel (
		UserId,UserName,AliasName,HeadIconPath,EmployeeId,EmployeeName,StationId,StationName,DeptId,DeptName,CorpId,CorpName,PositionId,PositionName
		)'

	IF (@TopCount <= 0)
	BEGIN
		SET @PreSql = @PreSql + ' SELECT '
	END
    ELSE
    BEGIN
		SET @PreSql = @PreSql + ' SELECT TOP (' + CAST(@TopCount AS VARCHAR(10)) + ')' 
	END
    
	SET @PreSql = @PreSql + ' A.UserId,A.UserName,A.AliasName,A.HeadIconPath,B.EmployeeId,B.EmployeeName,C.StationId,C.StationName,D.StruId AS DeptId,D.StruName AS DeptName,E.StruId AS CorpId,E.StruName AS CorpName,F.PositionId,F.PositionName '

	SET @LastSql = ' FROM dbo.TSys_User A
					 INNER JOIN dbo.TSys_Employee B ON A.UsedById = B.EmployeeId 
					 INNER JOIN dbo.TSys_Station C ON B.DefaultStationId = C.StationId
					 INNER JOIN #Stru D ON C.DeptId = D.StruId
					 INNER JOIN dbo.TSys_Structure E ON D.CorpId = E.StruId
					 LEFT JOIN dbo.TSys_Position F ON C.PositionId = F.PositionId
					 WHERE A.IsDelete = 0 AND A.UserType = 2 ' + @WhereClip

	--3.获取总记录数
	SET @Sql = ' SELECT @Total = COUNT(1) ' + @LastSql
	EXEC sp_executesql @Sql,N'@Total INT OUTPUT',@Total OUTPUT

	--4.获取表单数据
	IF @OrderByClip<>''
	BEGIN
		SET @LastSql=@LastSql+' ORDER BY ' + @OrderByClip
	END
	ELSE
	BEGIN
		SET @LastSql=@LastSql+' ORDER BY D.Outline,A.RowIndex,A.UserName '
	END

	SET @Sql=@PreSql+@LastSql
	EXEC sp_executesql @Sql

	--5.设置总页数
	IF (@Total = 0)
	BEGIN
		SET @FinalPageIndex = 0
		SET @PageSize = 0
	END
	ELSE
	BEGIN
		IF (@PageSize <= 0)
		BEGIN
			SET @PageSize = @Total
		END
		--设置总页数
		SELECT @FinalPageIndex = (@Total + @PageSize - 1) / @PageSize
	END		

	--6.获取需要跳过的行数
	IF (@FinalPageIndex < @PageIndex)
	BEGIN
		SET @PageIndex = @FinalPageIndex
	END
	IF (@PageIndex < 1)
	BEGIN
		SET @PageIndex = 1
	END

	SET @SkipRows = (@PageIndex - 1) * @PageSize

	--7.查询分页数据
	SELECT UserId,UserName,AliasName,HeadIconPath,EmployeeId,EmployeeName,StationId,StationName,DeptId,DeptName,CorpId,CorpName,PositionId,PositionName
	FROM #Personnel
	WHERE Idx > @SkipRows
	ORDER BY Idx

	--8.删除临时表
	DROP TABLE #Stru
	DROP TABLE #Personnel	

END













GO
