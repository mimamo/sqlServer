USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaWorksheetMarket]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tMediaWorksheetMarket](
	[MediaWorksheetKey] [int] NOT NULL,
	[MediaMarketKey] [int] NOT NULL,
 CONSTRAINT [PK_tMediaWorksheetMarket] PRIMARY KEY CLUSTERED 
(
	[MediaWorksheetKey] ASC,
	[MediaMarketKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
