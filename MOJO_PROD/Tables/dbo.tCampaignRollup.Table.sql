USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCampaignRollup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCampaignRollup](
	[CampaignKey] [int] NOT NULL,
	[CampaignSegmentKey] [int] NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[EstQty] [decimal](24, 4) NULL,
	[EstNet] [money] NULL,
	[EstGross] [money] NULL,
	[EstCOQty] [decimal](24, 4) NULL,
	[EstCONet] [money] NULL,
	[EstCOGross] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCampaignRollup] ADD  CONSTRAINT [DF_tCampaignRollup_EstQty]  DEFAULT ((0)) FOR [EstQty]
GO
ALTER TABLE [dbo].[tCampaignRollup] ADD  CONSTRAINT [DF_tCampaignRollup_EstCOQty]  DEFAULT ((0)) FOR [EstCOQty]
GO
