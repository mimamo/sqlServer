USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTask]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTask](
	[EstimateTaskKey] [int] IDENTITY(1,1) NOT NULL,
	[EstimateKey] [int] NULL,
	[TaskKey] [int] NULL,
	[Hours] [decimal](24, 4) NULL,
	[Rate] [money] NULL,
	[EstLabor] [money] NULL,
	[BudgetExpenses] [money] NULL,
	[Markup] [decimal](24, 4) NULL,
	[EstExpenses] [money] NULL,
	[Cost] [money] NULL,
	[Comments] [text] NULL,
 CONSTRAINT [PK_tEstimateTask] PRIMARY KEY NONCLUSTERED 
(
	[EstimateTaskKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateTask]  WITH CHECK ADD  CONSTRAINT [FK_tEstimateTask_tEstimate] FOREIGN KEY([EstimateKey])
REFERENCES [dbo].[tEstimate] ([EstimateKey])
GO
ALTER TABLE [dbo].[tEstimateTask] CHECK CONSTRAINT [FK_tEstimateTask_tEstimate]
GO
