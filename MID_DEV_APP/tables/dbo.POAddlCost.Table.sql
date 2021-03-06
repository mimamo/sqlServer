USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[POAddlCost]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POAddlCost](
	[AddlCostAccrAcct] [char](10) NOT NULL,
	[AddlCostAccrSub] [char](24) NOT NULL,
	[AddlCostExpAcct] [char](10) NOT NULL,
	[AddlCostExpSub] [char](24) NOT NULL,
	[AddlCostTypeID] [char](10) NOT NULL,
	[CostOverride] [smallint] NOT NULL,
	[CostReceived] [float] NOT NULL,
	[CostVouchered] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCostReceived] [float] NOT NULL,
	[CuryCostVouched] [float] NOT NULL,
	[CuryExpectedCost] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DfltPct] [float] NOT NULL,
	[ExpectedCost] [float] NOT NULL,
	[Labor_Class_CD] [char](4) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenLine] [smallint] NOT NULL,
	[PC_Flag] [char](1) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProrateMthd] [char](1) NOT NULL,
	[RcptStatus] [char](1) NOT NULL,
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
	[SeparateVoucher] [smallint] NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VouchStatus] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [AddlCostAccrAcct]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [AddlCostAccrSub]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [AddlCostExpAcct]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [AddlCostExpSub]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [AddlCostTypeID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CostOverride]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CostReceived]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CostVouchered]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CuryCostReceived]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CuryCostVouched]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CuryExpectedCost]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [DfltPct]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [ExpectedCost]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [Labor_Class_CD]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [OpenLine]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [ProrateMthd]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [RcptStatus]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [SeparateVoucher]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[POAddlCost] ADD  DEFAULT (' ') FOR [VouchStatus]
GO
