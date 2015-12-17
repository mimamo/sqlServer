USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskLabor]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTaskLabor](
	[EstimateKey] [int] NOT NULL,
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[UserKey] [int] NULL,
	[Hours] [decimal](24, 4) NOT NULL,
	[Rate] [money] NOT NULL,
	[Cost] [money] NULL,
	[CampaignSegmentKey] [int] NULL,
	[Comments] [text] NULL,
	[TitleKey] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateTaskLabor]  WITH CHECK ADD  CONSTRAINT [FK_tEstimateTaskLabor_tEstimate] FOREIGN KEY([EstimateKey])
REFERENCES [dbo].[tEstimate] ([EstimateKey])
GO
ALTER TABLE [dbo].[tEstimateTaskLabor] CHECK CONSTRAINT [FK_tEstimateTaskLabor_tEstimate]
GO
ALTER TABLE [dbo].[tEstimateTaskLabor] ADD  CONSTRAINT [DF_tEstimateTaskLabor_Hours]  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[tEstimateTaskLabor] ADD  CONSTRAINT [DF_tEstimateTaskLabor_Rate]  DEFAULT ((0)) FOR [Rate]
GO
ALTER TABLE [dbo].[tEstimateTaskLabor] ADD  CONSTRAINT [DF_tEstimateTaskLabor_Cost]  DEFAULT ((0)) FOR [Cost]
GO
