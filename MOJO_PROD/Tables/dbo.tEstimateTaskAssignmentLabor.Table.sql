USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskAssignmentLabor]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTaskAssignmentLabor](
	[EstimateKey] [int] NOT NULL,
	[TaskKey] [int] NULL,
	[TaskAssignmentKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[UserKey] [int] NULL,
	[Hours] [decimal](24, 4) NOT NULL,
	[Rate] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateTaskAssignmentLabor]  WITH CHECK ADD  CONSTRAINT [FK_tEstimateTaskAssignmentLabor_tEstimate] FOREIGN KEY([EstimateKey])
REFERENCES [dbo].[tEstimate] ([EstimateKey])
GO
ALTER TABLE [dbo].[tEstimateTaskAssignmentLabor] CHECK CONSTRAINT [FK_tEstimateTaskAssignmentLabor_tEstimate]
GO
ALTER TABLE [dbo].[tEstimateTaskAssignmentLabor] ADD  CONSTRAINT [DF_tEstimateTaskAssignmentLabor_Hours]  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[tEstimateTaskAssignmentLabor] ADD  CONSTRAINT [DF_tEstimateTaskAssignmentLabor_Rate]  DEFAULT ((0)) FOR [Rate]
GO
