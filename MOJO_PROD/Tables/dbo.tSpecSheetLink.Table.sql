USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSpecSheetLink]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSpecSheetLink](
	[SpecSheetKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
 CONSTRAINT [PK_tSpecSheetLink] PRIMARY KEY CLUSTERED 
(
	[SpecSheetKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
