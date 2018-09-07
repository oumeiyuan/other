--供方
/****** Object:  Table [dbo].[TSup_Supplier]    Script Date: 2018/4/20 17:48:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_Supplier](
	[SupId] [VARCHAR](36) NOT NULL,
	[SupName] [NVARCHAR](100) NOT NULL,
	[SupNo] [NVARCHAR](100) NULL,
	[ProvinceId] [VARCHAR](36) NOT NULL,
	[ProvinceName] [NVARCHAR](20) NOT NULL,
	[CityId] [VARCHAR](36) NOT NULL,
	[CityName] [NVARCHAR](20) NOT NULL,
	[AreaId] [VARCHAR](36) NOT NULL,
	[AreaName] [NVARCHAR](20) NOT NULL,
	[TaxPayerId] [INT] NULL,
	[EnterpriseForm] [INT] NULL,
	[CreditCode] [CHAR](18) NULL,
	[LegalRepresentative] [NVARCHAR](20) NULL,
	[RegisteredCapital] [NVARCHAR](50) NULL,
	[Address] [NVARCHAR](1000) NULL,
	[Postalcode] [VARCHAR](20) NULL,
	[OfficePhone] [VARCHAR](100) NULL,
	[FaxNumber] [VARCHAR](100) NULL,
	[Email] [VARCHAR](100) NULL,
	[OfficialWebsite] [NVARCHAR](1000) NULL,
	[BusinessLicence] [NVARCHAR](1000) NULL,
	[RowIndex] [INT] NOT NULL,
	[IsDelete] [BIT] NOT NULL,
	[Remark] [NVARCHAR](200) NULL,
	[CreateBy] [VARCHAR](36) NOT NULL,
	[CreateByName] [NVARCHAR](100) NOT NULL,
	[CreateDate] [DATETIME] NOT NULL,
	[LastEditBy] [VARCHAR](36) NOT NULL,
	[LastEditByName] [NVARCHAR](100) NOT NULL,
	[LastEditDate] [DATETIME] NOT NULL,
 CONSTRAINT [PK_dbo.TSup_Supplier] PRIMARY KEY CLUSTERED 
(
	[SupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--供方基础分类
/****** Object:  Table [dbo].[TSup_SupplierBaseClass]    Script Date: 2018/4/20 17:56:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierBaseClass](
	[ClassId] [VARCHAR](36) NOT NULL,
	[ClassName] [NVARCHAR](100) NOT NULL,
	[RowIndex] [INT] NOT NULL,
	[IsDelete] [BIT] NOT NULL,
	[Remark] [NVARCHAR](200) NULL,
	[CreateBy] [VARCHAR](36) NOT NULL,
	[CreateByName] [NVARCHAR](100) NOT NULL,
	[CreateDate] [DATETIME] NOT NULL,
	[LastEditBy] [VARCHAR](36) NOT NULL,
	[LastEditByName] [NVARCHAR](100) NOT NULL,
	[LastEditDate] [DATETIME] NOT NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierBaseClass] PRIMARY KEY CLUSTERED 
(
	[ClassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--供方分类
/****** Object:  Table [dbo].[TSup_SupplierClass]    Script Date: 2018/4/20 17:59:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierClass](
	[ClassId] [VARCHAR](36) NOT NULL,
	[ParentClassId] [VARCHAR](36) NULL,
	[ClassName] [NVARCHAR](100) NOT NULL,
	[BaseClassId] [VARCHAR](36) NOT NULL,
	[IsLeaf] [BIT] NOT NULL,
	[Level] [INT] NOT NULL,
	[Outline] [VARCHAR](100) NOT NULL,
	[RowIndex] [INT] NOT NULL,
	[IsDelete] [BIT] NOT NULL,
	[Remark] [NVARCHAR](200) NULL,
	[CreateBy] [VARCHAR](36) NOT NULL,
	[CreateByName] [NVARCHAR](100) NOT NULL,
	[CreateDate] [DATETIME] NOT NULL,
	[LastEditBy] [VARCHAR](36) NOT NULL,
	[LastEditByName] [NVARCHAR](100) NOT NULL,
	[LastEditDate] [DATETIME] NOT NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierClass] PRIMARY KEY CLUSTERED 
(
	[ClassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--供方分类关联表
/****** Object:  Table [dbo].[TSup_SupplierClassRelat]    Script Date: 2018/4/20 17:59:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierClassRelat](
	[SupId] [VARCHAR](36) NOT NULL,
	[ClassId] [VARCHAR](36) NOT NULL,
	[RowIndex] [INT] NOT NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierClassRelat] PRIMARY KEY CLUSTERED 
(
	[SupId] ASC,
	[ClassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--供方联系人
/****** Object:  Table [dbo].[TSup_SupplierContact]    Script Date: 2018/4/20 18:00:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierContact](
	[ContactId] [VARCHAR](36) NOT NULL,
	[SupId] [VARCHAR](36) NOT NULL,
	[ContactName] [NVARCHAR](100) NOT NULL,
	[PositionName] [NVARCHAR](50) NULL,
	[Sex] [BIT] NOT NULL,
	[Email] [VARCHAR](100) NULL,
	[OfficePhone] [VARCHAR](100) NULL,
	[MobileTelephone] [VARCHAR](100) NULL,
	[RowIndex] [INT] NOT NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierContact] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--供方合作案例
/****** Object:  Table [dbo].[TSup_SupplierCooperativeCase]    Script Date: 2018/4/20 18:00:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierCooperativeCase](
	[CooperativeId] [VARCHAR](36) NOT NULL,
	[SupId] [VARCHAR](36) NOT NULL,
	[CooperativeTypeId] [INT] NOT NULL,
	[CooperativeCompany] [NVARCHAR](100) NOT NULL,
	[CooperativeProjectName] [NVARCHAR](100) NOT NULL,
	[CooperativeRange] [NVARCHAR](100) NOT NULL,
	[ContractAmount] [DECIMAL](18, 2) NOT NULL,
	[CommencementDate] [DATETIME] NOT NULL,
	[CompletionDate] [DATETIME] NOT NULL,
	[RowIndex] [INT] NOT NULL,
	[Remark] [NVARCHAR](200) NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierCooperativeCase] PRIMARY KEY CLUSTERED 
(
	[CooperativeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--供方资质
/****** Object:  Table [dbo].[TSup_SupplierQualification]    Script Date: 2018/4/20 18:01:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierQualification](
	[QualificationId] [VARCHAR](36) NOT NULL,
	[QualificationName] [NVARCHAR](100) NOT NULL,
	[ClassId] [VARCHAR](36) NOT NULL,
	[RowIndex] [INT] NOT NULL,
	[Remark] [NVARCHAR](200) NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierQualification] PRIMARY KEY CLUSTERED 
(
	[QualificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


--供方资质文件
/****** Object:  Table [dbo].[TSup_SupplierQualificationFile]    Script Date: 2018/4/20 18:01:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TSup_SupplierQualificationFile](
	[FileId] [VARCHAR](36) NOT NULL,
	[FileName] [NVARCHAR](100) NOT NULL,
	[SupId] [VARCHAR](36) NOT NULL,
	[OriginalFilePath] [NVARCHAR](1000) NOT NULL,
	[ThumbnailFilePath] [NVARCHAR](1000) NULL,
	[ClassId] [VARCHAR](36) NOT NULL,
	[QualificationName] [VARCHAR](36) NOT NULL,
	[RowIndex] [INT] NOT NULL,
	[Remark] [NVARCHAR](200) NULL,
 CONSTRAINT [PK_dbo.TSup_SupplierQualificationFile] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




















