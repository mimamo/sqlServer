USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[WORouting]    Script Date: 12/21/2015 15:54:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WORouting](
	[ActualCost] [float] NOT NULL,
	[ActualHrs] [float] NOT NULL,
	[ActualLaborOvhFixed] [float] NOT NULL,
	[ActualLaborOvhVar] [float] NOT NULL,
	[ActualMachOvhFixed] [float] NOT NULL,
	[ActualMachOvhVar] [float] NOT NULL,
	[ActualScrap] [float] NOT NULL,
	[ActualUnits] [float] NOT NULL,
	[BudgetCst] [float] NOT NULL,
	[BudgetHrs] [float] NOT NULL,
	[CEngLbrHrs] [float] NOT NULL,
	[CEngMachHrs] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LaborClassID] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OperationID] [char](10) NOT NULL,
	[OperType] [char](1) NOT NULL,
	[PlanStart] [smalldatetime] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[StdRate] [float] NOT NULL,
	[StepAdded] [char](1) NOT NULL,
	[StepComplete] [char](1) NOT NULL,
	[StepHrs] [float] NOT NULL,
	[StepNbr] [smallint] NOT NULL,
	[Task] [char](32) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[WorkCenterID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualCost]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualHrs]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualLaborOvhFixed]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualLaborOvhVar]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualMachOvhFixed]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualMachOvhVar]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualScrap]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [ActualUnits]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [BudgetCst]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [BudgetHrs]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [CEngLbrHrs]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [CEngMachHrs]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [LaborClassID]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [OperationID]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [OperType]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [PlanStart]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [StdRate]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [StepAdded]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [StepComplete]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [StepHrs]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [StepNbr]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [Task]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[WORouting] ADD  DEFAULT (' ') FOR [WorkCenterID]
GO
