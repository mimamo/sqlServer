USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCampaignEstByItem]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCampaignEstByItem](
	[CampaignKey] [int] NOT NULL,
	[CampaignSegmentKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Qty] [decimal](24, 4) NOT NULL,
	[Net] [money] NOT NULL,
	[Gross] [money] NOT NULL,
	[COQty] [decimal](24, 4) NOT NULL,
	[CONet] [money] NOT NULL,
	[COGross] [money] NOT NULL,
 CONSTRAINT [PK_tCampaignEstByItem] PRIMARY KEY NONCLUSTERED 
(
	[CampaignKey] ASC,
	[CampaignSegmentKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCampaignEstByItem] ADD  CONSTRAINT [DF_tCampaignEstByItem_CampaignSegmentKey]  DEFAULT ((0)) FOR [CampaignSegmentKey]
GO
ALTER TABLE [dbo].[tCampaignEstByItem] ADD  CONSTRAINT [DF_tCampaignEstByItem_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[tCampaignEstByItem] ADD  CONSTRAINT [DF_tCampaignEstByItem_COQty]  DEFAULT ((0)) FOR [COQty]
GO
