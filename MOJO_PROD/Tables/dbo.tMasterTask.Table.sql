USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMasterTask]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMasterTask](
	[MasterTaskKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[TaskID] [varchar](30) NULL,
	[TaskName] [varchar](500) NOT NULL,
	[Description] [varchar](4000) NULL,
	[HourlyRate] [money] NULL,
	[Markup] [decimal](24, 4) NULL,
	[IOCommission] [decimal](24, 4) NULL,
	[BCCommission] [decimal](24, 4) NULL,
	[ShowDescOnEst] [tinyint] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[WorkTypeKey] [int] NULL,
	[ScheduleTask] [tinyint] NULL,
	[MoneyTask] [tinyint] NULL,
	[HideFromClient] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[TaskType] [smallint] NULL,
	[SummaryMasterTaskKey] [int] NULL,
	[PlanDuration] [int] NULL,
	[TrackBudget] [tinyint] NULL,
	[AllowAnyone] [tinyint] NULL,
	[PercCompSeparate] [tinyint] NULL,
	[WorkAnyDay] [tinyint] NULL,
	[TaskAssignmentTypeKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[Priority] [smallint] NULL,
	[WorkOrder] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tMasterTask] PRIMARY KEY CLUSTERED 
(
	[MasterTaskKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMasterTask] ADD  CONSTRAINT [DF_tMasterTask_ScheduleTask]  DEFAULT ((1)) FOR [ScheduleTask]
GO
ALTER TABLE [dbo].[tMasterTask] ADD  CONSTRAINT [DF_tMasterTask_MoneyTask]  DEFAULT ((1)) FOR [MoneyTask]
GO
ALTER TABLE [dbo].[tMasterTask] ADD  CONSTRAINT [DF_tMasterTask_HideFromClient]  DEFAULT ((0)) FOR [HideFromClient]
GO
ALTER TABLE [dbo].[tMasterTask] ADD  CONSTRAINT [DF__tMasterTa__LastM__65A448B2]  DEFAULT (getutcdate()) FOR [LastModified]
GO
