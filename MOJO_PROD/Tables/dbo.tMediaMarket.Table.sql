USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaMarket]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaMarket](
	[MediaMarketKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[MarketID] [varchar](50) NOT NULL,
	[MarketName] [varchar](200) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[Rank] [int] NULL,
	[POKind] [smallint] NULL,
 CONSTRAINT [PK_tMediaMarket] PRIMARY KEY CLUSTERED 
(
	[MediaMarketKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
