/****** Object:  Table [dbo].[TSys_BusinessEntryRole]    Script Date: 2018/4/21 15:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_BusinessEntryRole](
	[EntryId] [varchar](36) NOT NULL,
	[RoleId] [varchar](36) NOT NULL,
	[Type] [int] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TSys_BusinessEntryRole] PRIMARY KEY CLUSTERED 
(
	[EntryId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_BusinessEntryRoleUser]    Script Date: 2018/4/21 15:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_BusinessEntryRoleUser](
	[EntryId] [varchar](36) NOT NULL,
	[RoleId] [varchar](36) NOT NULL,
	[UserId] [varchar](36) NOT NULL,
	[RowIndex] [int] NOT NULL,
 CONSTRAINT [PK_TSys_BusinessEntryRoleUser] PRIMARY KEY CLUSTERED 
(
	[EntryId] ASC,
	[RoleId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_BusinessRole]    Script Date: 2018/4/21 15:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_BusinessRole](
	[RoleId] [varchar](36) NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
	[Type] [int] NOT NULL,
	[CategoryId] [varchar](36) NOT NULL,
	[RowIndex] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_BusinessRole] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_BusinessRoleCategory]    Script Date: 2018/4/21 15:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_BusinessRoleCategory](
	[CategoryId] [varchar](36) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[Type] [int] NOT NULL,
	[RowIndex] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[CreateBy] [varchar](36) NOT NULL,
	[CreateByName] [nvarchar](100) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastEditBy] [varchar](36) NOT NULL,
	[LastEditByName] [nvarchar](100) NOT NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TSys_BusinessCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
