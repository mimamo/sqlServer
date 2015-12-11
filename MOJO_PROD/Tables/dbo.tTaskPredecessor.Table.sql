USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTaskPredecessor]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTaskPredecessor](
	[TaskPredecessorKey] [int] IDENTITY(1,1) NOT NULL,
	[TaskKey] [int] NOT NULL,
	[PredecessorKey] [int] NOT NULL,
	[Type] [varchar](10) NOT NULL,
	[Lag] [int] NULL,
 CONSTRAINT [PK_tTaskPredecessor] PRIMARY KEY NONCLUSTERED 
(
	[TaskPredecessorKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTaskPredecessor]  WITH CHECK ADD  CONSTRAINT [FK_tTaskPredecessor_tTask] FOREIGN KEY([TaskKey])
REFERENCES [dbo].[tTask] ([TaskKey])
GO
ALTER TABLE [dbo].[tTaskPredecessor] CHECK CONSTRAINT [FK_tTaskPredecessor_tTask]
GO
ALTER TABLE [dbo].[tTaskPredecessor] ADD  CONSTRAINT [DF_tTaskPredecessor_Lag]  DEFAULT ((0)) FOR [Lag]
GO
