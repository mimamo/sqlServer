USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskTempPredecessor]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEstimateTaskTempPredecessor](
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NOT NULL,
	[TaskPredecessorKey] [int] NOT NULL,
	[TaskKey] [int] NOT NULL,
	[PredecessorKey] [int] NOT NULL,
	[Type] [varchar](10) NOT NULL,
	[Lag] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tEstimateTaskTempPredecessor] ADD  CONSTRAINT [DF_tEstimateTaskTempPredecessor_Lag]  DEFAULT ((0)) FOR [Lag]
GO
