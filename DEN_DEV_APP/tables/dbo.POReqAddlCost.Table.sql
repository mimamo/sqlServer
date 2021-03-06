USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[POReqAddlCost]    Script Date: 12/21/2015 14:05:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POReqAddlCost](
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
	[CuryIntmCuryID] [char](4) NOT NULL,
	[CuryIntmEffDate] [smalldatetime] NOT NULL,
	[CuryIntmMultDiv] [char](1) NOT NULL,
	[CuryIntmRate] [float] NOT NULL,
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
	[PC_Flag] [char](1) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProrateMthd] [char](1) NOT NULL,
	[RcptStatus] [char](1) NOT NULL,
	[ReqCntr] [char](2) NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_AddlCostAccrAcct]  DEFAULT (' ') FOR [AddlCostAccrAcct]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_AddlCostAccrSub]  DEFAULT (' ') FOR [AddlCostAccrSub]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_AddlCostExpAcct]  DEFAULT (' ') FOR [AddlCostExpAcct]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_AddlCostExpSub]  DEFAULT (' ') FOR [AddlCostExpSub]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_AddlCostTypeID]  DEFAULT (' ') FOR [AddlCostTypeID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CostOverride]  DEFAULT ((0)) FOR [CostOverride]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CostReceived]  DEFAULT ((0)) FOR [CostReceived]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CostVouchered]  DEFAULT ((0)) FOR [CostVouchered]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryCostReceived]  DEFAULT ((0)) FOR [CuryCostReceived]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryCostVouched]  DEFAULT ((0)) FOR [CuryCostVouched]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryExpectedCost]  DEFAULT ((0)) FOR [CuryExpectedCost]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryIntmCuryID]  DEFAULT (' ') FOR [CuryIntmCuryID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryIntmEffDate]  DEFAULT ('01/01/1900') FOR [CuryIntmEffDate]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryIntmMultDiv]  DEFAULT (' ') FOR [CuryIntmMultDiv]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryIntmRate]  DEFAULT ((0)) FOR [CuryIntmRate]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_DfltPct]  DEFAULT ((0)) FOR [DfltPct]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_ExpectedCost]  DEFAULT ((0)) FOR [ExpectedCost]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_Labor_Class_CD]  DEFAULT (' ') FOR [Labor_Class_CD]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_PC_Flag]  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_ProrateMthd]  DEFAULT (' ') FOR [ProrateMthd]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_RcptStatus]  DEFAULT (' ') FOR [RcptStatus]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_ReqCntr]  DEFAULT (' ') FOR [ReqCntr]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_ReqNbr]  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_SeparateVoucher]  DEFAULT ((0)) FOR [SeparateVoucher]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_VendID]  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[POReqAddlCost] ADD  CONSTRAINT [DF_POReqAddlCost_VouchStatus]  DEFAULT (' ') FOR [VouchStatus]
GO
