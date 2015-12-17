USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMarketingListListDeleteLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMarketingListListDeleteLog](
	[ModifiedByKey] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[StoredProc] [varchar](50) NOT NULL,
	[ParameterList] [varchar](2000) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Application] [varchar](50) NULL,
	[MarketingListKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[DateAdded] [smalldatetime] NULL,
	[ExternalMarketingKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
