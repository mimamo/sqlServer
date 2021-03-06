USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskLaborTitle]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTaskLaborTitle](
	[EstimateKey] [int] NOT NULL,
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[CampaignSegmentKey] [int] NULL,
	[TitleKey] [int] NOT NULL,
	[Hours] [decimal](24, 4) NOT NULL,
	[Rate] [money] NOT NULL,
	[Gross] [money] NOT NULL,
	[Cost] [money] NULL
) ON [PRIMARY]
GO
