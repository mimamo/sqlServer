USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskLaborLevel]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTaskLaborLevel](
	[EstimateKey] [int] NOT NULL,
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NOT NULL,
	[RateLevel] [smallint] NOT NULL,
	[Hours] [decimal](24, 4) NOT NULL,
	[Rate] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateTaskLaborLevel] ADD  CONSTRAINT [DF_tEstimateTaskLaborLevel_RateLevel]  DEFAULT ((1)) FOR [RateLevel]
GO
ALTER TABLE [dbo].[tEstimateTaskLaborLevel] ADD  CONSTRAINT [DF_tEstimateTaskLaborLevel_Hours]  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[tEstimateTaskLaborLevel] ADD  CONSTRAINT [DF_tEstimateTaskLaborLevel_Rate]  DEFAULT ((0)) FOR [Rate]
GO
