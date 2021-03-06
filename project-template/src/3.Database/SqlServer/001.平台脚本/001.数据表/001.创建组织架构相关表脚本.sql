/****** Object:  Table [dbo].[TSys_Employee]    Script Date: 2018/2/28 11:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_Employee](
	[EmployeeId] [varchar](36) NOT NULL,
	[EmployeeNo] [nvarchar](100) NOT NULL,
	[EmployeeName] [nvarchar](100) NOT NULL,
	[HeadIconPath] [nvarchar](1000) NULL,
	[Sex] [int] NOT NULL,
	[Birthday] [datetime] NOT NULL,
	[OriginPlace] [nvarchar](50) NULL,
	[Address] [nvarchar](500) NULL,
	[EntryDate] [datetime] NOT NULL,
	[DefaultStationId] [varchar](36) NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[RowIndex] [int] NOT NULL,
	[MobileTelephone] [varchar](100) NULL,
	[OfficePhone] [varchar](100) NULL,
	[QQ] [varchar](100) NULL,
	[WeChat] [varchar](100) NULL,
	[MicroBlog] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
 CONSTRAINT [PK_dbo.TSys_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_Position]    Script Date: 2018/2/28 11:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_Position](
	[PositionId] [varchar](36) NOT NULL,
	[PositionName] [nvarchar](200) NOT NULL,
	[PositionNo] [nvarchar](100) NULL,
	[Grade] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[RowIndex] [int] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_Position] PRIMARY KEY CLUSTERED 
(
	[PositionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_Station]    Script Date: 2018/2/28 11:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_Station](
	[StationId] [varchar](36) NOT NULL,
	[StationName] [nvarchar](50) NOT NULL,
	[StationNo] [nvarchar](100) NULL,
	[DeptId] [varchar](36) NOT NULL,
	[EmployeeId] [varchar](36) NULL,
	[LeaderStationId] [varchar](36) NULL,
	[PositionId] [varchar](36) NULL,
	[Description] [nvarchar](1000) NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[RowIndex] [int] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_Station] PRIMARY KEY CLUSTERED 
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_Structure]    Script Date: 2018/2/28 11:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_Structure](
	[StruId] [varchar](36) NOT NULL,
	[StruName] [nvarchar](100) NOT NULL,
	[FullName] [nvarchar](200) NULL,
	[StruNo] [nvarchar](100) NULL,
	[ParentStruId] [varchar](36) NULL,
	[StruType] [int] NOT NULL,
	[CorpId] [varchar](36) NOT NULL,
	[IconPath] [nvarchar](1000) NULL,
	[DeptHeaderId] [varchar](36) NULL,
	[ChargeLeaderId] [varchar](36) NULL,
	[FunctionHigherId] [varchar](36) NULL,
	[RowIndex] [int] NOT NULL,
	[Outline] [varchar](100) NOT NULL,
	[IsLeaf] [bit] NOT NULL,
	[Level] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_Structure] PRIMARY KEY CLUSTERED 
(
	[StruId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Idx_EmployeeNo_IsDelete]    Script Date: 2018/2/28 11:10:09 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Idx_EmployeeNo_IsDelete] ON [dbo].[TSys_Employee]
(
	[EmployeeNo] ASC,
	[IsDelete] ASC
)
WHERE ([IsDelete]=(0))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Idx_PositionName_IsDelete]    Script Date: 2018/2/28 11:10:09 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Idx_PositionName_IsDelete] ON [dbo].[TSys_Position]
(
	[PositionName] ASC,
	[IsDelete] ASC
)
WHERE ([IsDelete]=(0))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Idx_StationNo_IsDelete]    Script Date: 2018/2/28 11:10:09 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Idx_StationNo_IsDelete] ON [dbo].[TSys_Station]
(
	[StationNo] ASC,
	[IsDelete] ASC
)
WHERE ([IsDelete]=(0))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Idx_StruName_ParentStruId_IsDelete]    Script Date: 2018/2/28 11:10:09 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Idx_StruName_ParentStruId_IsDelete] ON [dbo].[TSys_Structure]
(
	[StruName] ASC,
	[ParentStruId] ASC,
	[IsDelete] ASC
)
WHERE ([IsDelete]=(0))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
