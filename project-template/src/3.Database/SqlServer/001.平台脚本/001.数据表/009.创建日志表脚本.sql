
/****** Object:  Table [dbo].[TSys_ExceptionLog]    Script Date: 2018/1/17 10:30:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_ExceptionLog](
	[LogId] [varchar](36) NOT NULL,
	[UserId] [varchar](36) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[AliasName] [nvarchar](100) NOT NULL,
	[UserAddress] [nvarchar](500) NOT NULL,
	[ClientId] [varchar](36) NOT NULL,
	[ClientName] [nvarchar](100) NOT NULL,
	[Type] [int] NOT NULL,
	[Message] [nvarchar](2000) NOT NULL,
	[StackTrace] [nvarchar](max) NULL,
	[Source] [nvarchar](1000) NOT NULL,
	[ExceptionTime] [datetime] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_ExceptionLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_UserAccessLog]    Script Date: 2018/1/17 10:30:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_UserAccessLog](
	[LogId] [varchar](36) NOT NULL,
	[AccessTime] [datetime] NOT NULL,
	[UserId] [varchar](36) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[AliasName] [nvarchar](100) NOT NULL,
	[ClientId] [varchar](36) NOT NULL,
	[ClientName] [nvarchar](100) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Source] [nvarchar](1000) NOT NULL,
	[UserAddress] [nvarchar](500) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_UserAccessLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_UserLoginLog]    Script Date: 2018/1/17 10:30:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_UserLoginLog](
	[LogId] [varchar](36) NOT NULL,
	[LoginTime] [datetime] NOT NULL,
	[UserId] [varchar](36) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[AliasName] [nvarchar](100) NOT NULL,
	[ClientId] [varchar](36) NOT NULL,
	[ClientName] [nvarchar](100) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Source] [nvarchar](1000) NOT NULL,
	[UserAddress] [nvarchar](500) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_UserLoginLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_UserOperateLog]    Script Date: 2018/1/17 10:30:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_UserOperateLog](
	[LogId] [varchar](36) NOT NULL,
	[OperateTime] [datetime] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[UserId] [varchar](36) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[AliasName] [nvarchar](100) NOT NULL,
	[ClientId] [varchar](36) NOT NULL,
	[ClientName] [nvarchar](100) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Source] [nvarchar](1000) NOT NULL,
	[UserAddress] [nvarchar](500) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_UserOperateLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
