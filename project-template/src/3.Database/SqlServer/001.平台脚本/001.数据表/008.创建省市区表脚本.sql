
CREATE TABLE [dbo].[TSys_Province](
	[Id] [varchar](10) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[AliasName] [nvarchar](20) NOT NULL,
	[ShortName] [nvarchar](5) NOT NULL,
	[Spell] [varchar](100) NOT NULL,
	[FirstChar] [char](1) NOT NULL,
	[Position] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.TSys_Province] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[TSys_City](
	[Id] [varchar](10) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[AliasName] [nvarchar](20) NOT NULL,
	[Spell] [varchar](100) NOT NULL,
	[FirstChar] [char](1) NOT NULL,
	[ProvinceId] [varchar](10) NOT NULL,
	[Position] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.TSys_City] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[TSys_Area](
	[Id] [varchar](10) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[AliasName] [nvarchar](20) NOT NULL,
	[Spell] [varchar](100) NOT NULL,
	[FirstChar] [char](1) NOT NULL,
	[CityId] [varchar](10) NOT NULL,
	[ProvinceId] [varchar](10) NOT NULL,
	[Position] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.TSys_Area] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

