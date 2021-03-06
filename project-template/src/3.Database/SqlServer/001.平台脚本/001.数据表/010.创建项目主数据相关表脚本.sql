/****** Object:  Table [dbo].[TBas_FormType]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_FormType](
	[TypeId] [varchar](36) NOT NULL,
	[TypeName] [nvarchar](100) NOT NULL,
	[ParentTypeId] [varchar](36) NULL,
	[BaseFormType] [int] NOT NULL,
	[Remark] [nvarchar](200) NULL,
	[IsDelete] [bit] NOT NULL,
	[RowIndex] [int] NOT NULL,
	[IsLeaf] [bit] NOT NULL,
	[Level] [int] NOT NULL,
	[Outline] [varchar](100) NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TBas_FormType] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_Land]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_Land](
	[LandId] [varchar](36) NOT NULL,
	[LandName] [nvarchar](100) NOT NULL,
	[LandAddress] [nvarchar](200) NOT NULL,
	[ProvinceId] [varchar](36) NOT NULL,
	[ProvinceName] [nvarchar](20) NOT NULL,
	[CityId] [varchar](36) NOT NULL,
	[CityName] [nvarchar](20) NOT NULL,
	[AreaId] [varchar](36) NULL,
	[AreaName] [nvarchar](20) NULL,
	[LandNo] [nvarchar](100) NOT NULL,
	[LandMapPosition] [varchar](1000) NULL,
	[LandArea] [nvarchar](100) NULL,
	[IsBidInvitation] [bit] NOT NULL,
	[LandUsage] [nvarchar](20) NULL,
	[GrantYear] [nvarchar](10) NULL,
	[RowIndex] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
	[Remark] [nvarchar](200) NULL,
 CONSTRAINT [PK_dbo.TBas_Land] PRIMARY KEY CLUSTERED 
(
	[LandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_ProfessionalType]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_ProfessionalType](
	[TypeId] [varchar](36) NOT NULL,
	[TypeName] [nvarchar](100) NOT NULL,
	[Remark] [nvarchar](200) NULL,
	[RowIndex] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TBas_ProfessionalType] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_Project]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_Project](
	[ProjectId] [varchar](36) NOT NULL,
	[ProjectName] [nvarchar](100) NOT NULL,
	[ProjectNo] [nvarchar](100) NOT NULL,
	[StatusId] [varchar](36) NOT NULL,
	[ParentProjectId] [varchar](36) NULL,
	[CorpId] [varchar](36) NOT NULL,
	[ProvinceId] [varchar](36) NULL,
	[ProvinceName] [nvarchar](20) NULL,
	[CityId] [varchar](36) NULL,
	[CityName] [nvarchar](20) NULL,
	[AreaId] [varchar](36) NULL,
	[AreaName] [nvarchar](20) NULL,
	[IsPurchased] [bit] NULL,
	[TypeId] [varchar](36) NULL,
	[TypeName] [nvarchar](100) NULL,
	[ProjectAddress] [nvarchar](1000) NULL,
	[ProjectMapPosition] [varchar](1000) NULL,
	[ProjectImgUrl1] [nvarchar](1000) NULL,
	[ProjectImgUrl2] [nvarchar](1000) NULL,
	[ProjectImgThumbnail] [nvarchar](1000) NULL,
	[Remark] [nvarchar](200) NULL,
	[IsDelete] [bit] NOT NULL,
	[RowIndex] [int] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TBas_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_ProjectBuilding]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_ProjectBuilding](
	[BuildingId] [varchar](36) NOT NULL,
	[ProjectId] [varchar](36) NOT NULL,
	[BuildingName] [nvarchar](100) NOT NULL,
	[BuildingNo] [nvarchar](100) NULL,
	[IsSell] [bit] NOT NULL,
	[BaseFormType] [int] NOT NULL,
	[Floors] [int] NOT NULL,
	[FormTypeId] [varchar](36) NOT NULL,
	[FormTypeName] [nvarchar](100) NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[RowIndex] [int] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TBas_ProjectBuilding] PRIMARY KEY CLUSTERED 
(
	[BuildingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_ProjectLand]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_ProjectLand](
	[ProjectId] [varchar](36) NOT NULL,
	[LandId] [varchar](36) NOT NULL,
	[RowIndex] [int] NULL,
 CONSTRAINT [PK_TBas_ProjectLand] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC,
	[LandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_ProjectPeriod]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_ProjectPeriod](
	[PeriodId] [varchar](36) NOT NULL,
	[PeriodName] [nvarchar](100) NOT NULL,
	[Remark] [nvarchar](200) NULL,
	[RowIndex] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TBas_ProjectPeriod] PRIMARY KEY CLUSTERED 
(
	[PeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_ProjectStatus]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_ProjectStatus](
	[StatusId] [varchar](36) NOT NULL,
	[StatusName] [nvarchar](20) NOT NULL,
	[Remark] [nvarchar](200) NULL,
	[RowIndex] [int] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TBas_ProjectStatus] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBas_ProjectType]    Script Date: 2018/2/27 9:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBas_ProjectType](
	[TypeId] [varchar](36) NOT NULL,
	[TypeName] [nvarchar](100) NOT NULL,
	[Remark] [nvarchar](200) NULL,
	[RowIndex] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TBas_ProjectType] PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
