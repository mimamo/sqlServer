USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTask]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTask](
	[TaskKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[TaskID] [varchar](30) NULL,
	[TaskName] [varchar](500) NOT NULL,
	[Description] [varchar](6000) NULL,
	[MasterTaskKey] [int] NULL,
	[TaskType] [smallint] NOT NULL,
	[SummaryTaskKey] [int] NULL,
	[DisplayOrder] [int] NOT NULL,
	[HourlyRate] [money] NULL,
	[Markup] [decimal](24, 4) NULL,
	[IOCommission] [decimal](24, 4) NULL,
	[BCCommission] [decimal](24, 4) NULL,
	[ShowDescOnEst] [tinyint] NULL,
	[ShowEstimateDetail] [smallint] NULL,
	[RollupOnEstimate] [smallint] NULL,
	[RollupOnInvoice] [smallint] NULL,
	[Visibility] [smallint] NULL,
	[ServiceKey] [int] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[WorkTypeKey] [int] NULL,
	[PlanStart] [smalldatetime] NULL,
	[PlanComplete] [smalldatetime] NULL,
	[PlanDuration] [int] NULL,
	[ActStart] [smalldatetime] NULL,
	[ActComplete] [smalldatetime] NULL,
	[PercComp] [int] NULL,
	[TaskStatus] [smallint] NULL,
	[TaskConstraint] [smallint] NULL,
	[ScheduleNote] [varchar](200) NULL,
	[Comments] [varchar](4000) NULL,
	[BaseStart] [smalldatetime] NULL,
	[BaseComplete] [smalldatetime] NULL,
	[ScheduleTask] [tinyint] NULL,
	[MoneyTask] [tinyint] NULL,
	[HideFromClient] [tinyint] NULL,
	[ProjectOrder] [int] NULL,
	[TaskLevel] [int] NULL,
	[EstHours] [decimal](24, 4) NOT NULL,
	[EstLabor] [money] NOT NULL,
	[BudgetExpenses] [money] NOT NULL,
	[EstExpenses] [money] NOT NULL,
	[ApprovedCOHours] [decimal](24, 4) NOT NULL,
	[ApprovedCOLabor] [money] NOT NULL,
	[ApprovedCOExpense] [money] NOT NULL,
	[ApprovedCOBudgetExp] [money] NULL,
	[Contingency] [money] NULL,
	[BudgetLabor] [money] NULL,
	[ApprovedCOBudgetLabor] [money] NULL,
	[AllowAnyone] [tinyint] NULL,
	[TrackBudget] [tinyint] NULL,
	[ConstraintDate] [datetime] NULL,
	[PercCompSeparate] [tinyint] NULL,
	[WorkAnyDay] [tinyint] NULL,
	[PredecessorsComplete] [tinyint] NULL,
	[TaskAssignmentTypeKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[ReviewedByTraffic] [tinyint] NULL,
	[ReviewedByDate] [smalldatetime] NULL,
	[ReviewedByKey] [int] NULL,
	[EventStart] [datetime] NULL,
	[EventEnd] [datetime] NULL,
	[ShowOnCalendar] [tinyint] NULL,
	[TaskAssignmentKey] [int] NULL,
	[Priority] [smallint] NULL,
	[TimeZoneIndex] [int] NULL,
	[DueBy] [varchar](200) NULL,
	[BudgetTaskKey] [int] NULL,
	[CompletedByDate] [datetime] NULL,
	[CompletedByKey] [int] NULL,
	[TimeZoneConverted] [tinyint] NULL,
	[TotalActualHours] [decimal](24, 4) NULL,
	[TotalAllocatedHours] [decimal](24, 4) NULL,
	[AssignedNames] [varchar](2000) NULL,
	[TimelineSegmentKey] [int] NULL,
	[UserChangedDate] [smalldatetime] NULL,
	[ConstraintDayOfTheWeek] [int] NULL,
	[ExcludeFromStatus] [tinyint] NULL,
	[TimelineSegmentDisplayName] [varchar](200) NULL,
	[AllowAllocatedHours] [tinyint] NOT NULL,
 CONSTRAINT [PK_tTask] PRIMARY KEY CLUSTERED 
(
	[TaskKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_PlanDuration]  DEFAULT ((1)) FOR [PlanDuration]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_TaskStatus]  DEFAULT ((1)) FOR [TaskStatus]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_TaskConstraint]  DEFAULT ((0)) FOR [TaskConstraint]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ShowOnSchedule]  DEFAULT ((1)) FOR [ScheduleTask]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_MoneyTask]  DEFAULT ((1)) FOR [MoneyTask]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_HideFromClient]  DEFAULT ((0)) FOR [HideFromClient]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_EstHours]  DEFAULT ((0)) FOR [EstHours]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_EstLabor]  DEFAULT ((0)) FOR [EstLabor]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_BudgetExpenses]  DEFAULT ((0)) FOR [BudgetExpenses]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_EstExpenses]  DEFAULT ((0)) FOR [EstExpenses]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ApprovedCOHours]  DEFAULT ((0)) FOR [ApprovedCOHours]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ApprovedCOLabor]  DEFAULT ((0)) FOR [ApprovedCOLabor]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ApprovedCOExpense]  DEFAULT ((0)) FOR [ApprovedCOExpense]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ApprovedCOBudgetExp]  DEFAULT ((0)) FOR [ApprovedCOBudgetExp]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_Contingency]  DEFAULT ((0)) FOR [Contingency]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_BudgetLabor]  DEFAULT ((0)) FOR [BudgetLabor]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ApprovedCOBudgetLabor]  DEFAULT ((0)) FOR [ApprovedCOBudgetLabor]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_PercCompSeparate]  DEFAULT ((0)) FOR [PercCompSeparate]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_WorkAnyDay]  DEFAULT ((0)) FOR [WorkAnyDay]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_PredecessorsComplete]  DEFAULT ((0)) FOR [PredecessorsComplete]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_EventEnd]  DEFAULT ((0)) FOR [EventEnd]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ConstraintDayOfTheWeek]  DEFAULT ((0)) FOR [ConstraintDayOfTheWeek]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_ExcludeFromStatus]  DEFAULT ((0)) FOR [ExcludeFromStatus]
GO
ALTER TABLE [dbo].[tTask] ADD  CONSTRAINT [DF_tTask_AllowAllocatedHours]  DEFAULT ((0)) FOR [AllowAllocatedHours]
GO
