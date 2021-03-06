USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCampaignEstByTitle]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCampaignEstByTitle](
	[CampaignKey] [int] NOT NULL,
	[CampaignSegmentKey] [int] NOT NULL,
	[TitleKey] [int] NOT NULL,
	[Qty] [decimal](24, 4) NOT NULL,
	[Net] [money] NOT NULL,
	[Gross] [money] NOT NULL,
	[COQty] [decimal](24, 4) NOT NULL,
	[CONet] [money] NOT NULL,
	[COGross] [money] NOT NULL,
 CONSTRAINT [PK_tCampaignEstByTitle] PRIMARY KEY NONCLUSTERED 
(
	[CampaignKey] ASC,
	[CampaignSegmentKey] ASC,
	[TitleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCampaignEstByTitle] ADD  CONSTRAINT [DF_tCampaignEstByTitle_CampaignSegmentKey]  DEFAULT ((0)) FOR [CampaignSegmentKey]
GO
ALTER TABLE [dbo].[tCampaignEstByTitle] ADD  CONSTRAINT [DF_tCampaignEstByTitle_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[tCampaignEstByTitle] ADD  CONSTRAINT [DF_tCampaignEstByTitle_COQty]  DEFAULT ((0)) FOR [COQty]
GO
