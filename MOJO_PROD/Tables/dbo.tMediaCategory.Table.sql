USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaCategory]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaCategory](
	[MediaCategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[POKind] [smallint] NOT NULL,
	[CategoryID] [varchar](50) NOT NULL,
	[CategoryName] [varchar](1000) NOT NULL,
	[CategoryShortName] [varchar](100) NULL,
	[Description] [varchar](max) NULL,
	[Active] [tinyint] NULL,
	[ItemKey] [int] NULL,
 CONSTRAINT [PK_tMediaCategory] PRIMARY KEY CLUSTERED 
(
	[MediaCategoryKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
