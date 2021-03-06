USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWebDavServer]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWebDavServer](
	[WebDavServerKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[URL] [varchar](1000) NULL,
	[ClientFolder] [smallint] NULL,
	[ClientSep] [varchar](3) NULL,
	[ProjectFolder] [smallint] NULL,
	[ProjectSep] [varchar](3) NULL,
	[Type] [smallint] NULL,
	[UserID] [varchar](50) NULL,
	[Password] [varchar](1000) NULL,
	[RootPath] [varchar](1000) NULL,
	[PreTokenKey] [varchar](1000) NULL,
	[AuthToken] [varchar](1000) NULL,
	[Name] [varchar](200) NULL,
	[RefreshToken] [varchar](1000) NULL,
	[AuthTokenDate] [smalldatetime] NULL,
	[RefreshTokenDate] [smalldatetime] NULL,
	[RefreshingToken] [tinyint] NULL,
 CONSTRAINT [PK_tWebDavURL] PRIMARY KEY CLUSTERED 
(
	[WebDavServerKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
