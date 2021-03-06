/****** Object:  Table [dbo].[TSys_Client]    Script Date: 2018/2/26 19:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_Client](
	[ClientId] [varchar](36) NOT NULL,
	[ClientSecret] [varchar](200) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[RefreshTokenLifeTime] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[IsSystem] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_Client] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TSys_Config]    Script Date: 2018/2/26 19:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TSys_Config](
	[ConfigId] [varchar](36) NOT NULL,
	[ConfigName] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[LastEditDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TSys_Config] PRIMARY KEY CLUSTERED 
(
	[ConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
