USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTaskAssignment]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTaskAssignment](
	[TaskAssignmentKey] [int] IDENTITY(1,1) NOT NULL,
	[TaskKey] [int] NOT NULL,
	[UserKey] [int] NULL,
	[TaskAssignmentTypeKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[AssignmentPercent] [int] NOT NULL,
	[Priority] [smallint] NOT NULL,
	[WorkOrder] [int] NOT NULL,
	[Title] [varchar](500) NULL,
	[DueBy] [varchar](200) NULL,
	[WorkDescription] [varchar](4000) NULL,
	[PredecessorsComplete] [tinyint] NULL,
	[BaseStart] [smalldatetime] NULL,
	[BaseComplete] [smalldatetime] NULL,
	[MustStartOn] [smalldatetime] NULL,
	[PlanStart] [smalldatetime] NULL,
	[PlanComplete] [smalldatetime] NULL,
	[Duration] [int] NULL,
	[ActStart] [smalldatetime] NULL,
	[ActComplete] [smalldatetime] NULL,
	[PercComp] [int] NULL,
	[Comments] [varchar](4000) NULL,
	[HideFromClient] [tinyint] NULL,
	[ReviewedByTraffic] [tinyint] NULL,
	[ReviewedByDate] [smalldatetime] NULL,
	[ReviewedByKey] [int] NULL,
 CONSTRAINT [PK_tTaskAssignment] PRIMARY KEY NONCLUSTERED 
(
	[TaskAssignmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_AssignmentPercent]  DEFAULT ((100)) FOR [AssignmentPercent]
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_Priority]  DEFAULT ((2)) FOR [Priority]
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_WorkOrder]  DEFAULT ((1)) FOR [WorkOrder]
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_PredecessorsComplete]  DEFAULT ((0)) FOR [PredecessorsComplete]
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_Duration]  DEFAULT ((0)) FOR [Duration]
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_PercComp]  DEFAULT ((0)) FOR [PercComp]
GO
ALTER TABLE [dbo].[tTaskAssignment] ADD  CONSTRAINT [DF_tTaskAssignment_VisibleToClient]  DEFAULT ((0)) FOR [HideFromClient]
GO
