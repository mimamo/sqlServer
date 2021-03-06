USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[WOHeader]    Script Date: 12/21/2015 14:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOHeader](
	[BackFlush] [char](1) NOT NULL,
	[BackflushLabor] [char](1) NOT NULL,
	[BackflushMaterial] [char](1) NOT NULL,
	[BOMStatus] [char](1) NOT NULL,
	[BTLineCntr] [smallint] NOT NULL,
	[BuildToProj] [char](16) NOT NULL,
	[BuildToTask] [char](32) NOT NULL,
	[BuildToType] [char](3) NOT NULL,
	[BuildToWO] [char](16) NOT NULL,
	[CompCostMethod] [char](1) NOT NULL,
	[CompDfltSite] [char](1) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[DBProcessStatus] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[Labor_Acct] [char](16) NOT NULL,
	[LaborBdgUpdate] [char](1) NOT NULL,
	[LastRoutingStepNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Material_Acct] [char](16) NOT NULL,
	[MaterialBdgUpdate] [char](1) NOT NULL,
	[MRLineCntr] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[PlanEnd] [smalldatetime] NOT NULL,
	[PlanStart] [smalldatetime] NOT NULL,
	[Priority] [smallint] NOT NULL,
	[PrjWoGLIM] [char](1) NOT NULL,
	[ProcStage] [char](1) NOT NULL,
	[QtyComplete] [float] NOT NULL,
	[QtyCurrent] [float] NOT NULL,
	[QtyGridPopToDate] [float] NOT NULL,
	[QtyOrig] [float] NOT NULL,
	[QtyQCHold] [float] NOT NULL,
	[QtyRemaining] [float] NOT NULL,
	[QtyRework] [float] NOT NULL,
	[QtyReworkComp] [float] NOT NULL,
	[QtyScrap] [float] NOT NULL,
	[RLineCntr] [smallint] NOT NULL,
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
	[ScheduleMaterials] [char](1) NOT NULL,
	[ScheduleOption] [char](1) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StdCostLast] [float] NOT NULL,
	[StdCostOrig] [float] NOT NULL,
	[StdCostWO] [float] NOT NULL,
	[StdLotSize] [float] NOT NULL,
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
	[WhseLoc] [char](10) NOT NULL,
	[WIPIntegrity] [smallint] NOT NULL,
	[WODescr] [char](60) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[WOType] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BackFlush]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BackflushLabor]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BackflushMaterial]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BOMStatus]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [BTLineCntr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BuildToProj]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BuildToTask]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BuildToType]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [BuildToWO]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [CompCostMethod]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [CompDfltSite]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [DBProcessStatus]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [Labor_Acct]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [LaborBdgUpdate]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [LastRoutingStepNbr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [Material_Acct]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [MaterialBdgUpdate]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [MRLineCntr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [PlanEnd]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [PlanStart]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [PrjWoGLIM]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [ProcStage]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyComplete]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyCurrent]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyGridPopToDate]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyOrig]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyQCHold]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyRemaining]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyRework]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyReworkComp]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [QtyScrap]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [RLineCntr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [ScheduleMaterials]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [ScheduleOption]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [StdCostLast]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [StdCostOrig]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [StdCostWO]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [StdLotSize]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT ((0)) FOR [WIPIntegrity]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [WODescr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[WOHeader] ADD  DEFAULT (' ') FOR [WOType]
GO
