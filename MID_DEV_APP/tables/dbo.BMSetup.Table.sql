USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[BMSetup]    Script Date: 12/21/2015 14:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BMSetup](
	[AutoRef] [smallint] NOT NULL,
	[BOMSeqAssign] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CstRollOffVarAcct] [char](10) NOT NULL,
	[CstRollOffVarSub] [char](24) NOT NULL,
	[DecPlHrs] [smallint] NOT NULL,
	[DfltDirectLbrAC] [char](16) NOT NULL,
	[DfltDirectMtlAC] [char](16) NOT NULL,
	[DfltDirectOtherAC] [char](16) NOT NULL,
	[DfltOvhLbrFixedAC] [char](16) NOT NULL,
	[DfltOvhLbrFixedRate] [float] NOT NULL,
	[DfltOvhLbrVarAC] [char](16) NOT NULL,
	[DfltOvhLbrVarRate] [float] NOT NULL,
	[DfltOvhMachFixedAC] [char](16) NOT NULL,
	[DfltOvhMachFixedRate] [float] NOT NULL,
	[DfltOvhMachVarAC] [char](16) NOT NULL,
	[DfltOvhMachVarRate] [float] NOT NULL,
	[DfltOvhMtlFixedAC] [char](16) NOT NULL,
	[DfltOvhMtlFixedRate] [float] NOT NULL,
	[DfltOvhMtlVarAC] [char](16) NOT NULL,
	[DfltOvhMtlVarRate] [float] NOT NULL,
	[GlbSiteID] [char](10) NOT NULL,
	[LastRefNbr] [char](10) NOT NULL,
	[LbrACOvhSource] [char](1) NOT NULL,
	[LbrDirOffAcct] [char](10) NOT NULL,
	[LbrDirOffSub] [char](24) NOT NULL,
	[LbrDirScrapVarAcct] [char](10) NOT NULL,
	[LbrDirScrapVarSub] [char](24) NOT NULL,
	[LbrDirVarAcct] [char](10) NOT NULL,
	[LbrDirVarSub] [char](24) NOT NULL,
	[LbrOvhOffAcct] [char](10) NOT NULL,
	[LbrOvhOffSub] [char](24) NOT NULL,
	[LbrOvhRatePct] [char](1) NOT NULL,
	[LbrOvhScrapVarAcct] [char](10) NOT NULL,
	[LbrOvhScrapVarSub] [char](24) NOT NULL,
	[LbrOvhVarAcct] [char](10) NOT NULL,
	[LbrOvhVarSub] [char](24) NOT NULL,
	[LowLevelFlag] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MachOvhOffAcct] [char](10) NOT NULL,
	[MachOvhOffSub] [char](24) NOT NULL,
	[MachOvhScrapVarAcct] [char](10) NOT NULL,
	[MachOvhScrapVarSub] [char](24) NOT NULL,
	[MachOvhVarAcct] [char](10) NOT NULL,
	[MachOvhVarSub] [char](24) NOT NULL,
	[MatlDirScrapVarAcct] [char](10) NOT NULL,
	[MatlDirScrapVarSub] [char](24) NOT NULL,
	[MatlDirVarAcct] [char](10) NOT NULL,
	[MatlDirVarSub] [char](24) NOT NULL,
	[MatlOvhCalc] [char](1) NOT NULL,
	[MatlOvhOffAcct] [char](10) NOT NULL,
	[MatlOvhOffSub] [char](24) NOT NULL,
	[MatlOvhRatePct] [char](1) NOT NULL,
	[MatlOvhScrapVarAcct] [char](10) NOT NULL,
	[MatlOvhScrapVarSub] [char](24) NOT NULL,
	[MatlOvhVarAcct] [char](10) NOT NULL,
	[MatlOvhVarSub] [char](24) NOT NULL,
	[MCTypeBusFlg] [char](1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OthDirOffAcct] [char](10) NOT NULL,
	[OthDirOffSub] [char](24) NOT NULL,
	[OthDirScrapVarAcct] [char](10) NOT NULL,
	[OthDirScrapVarSub] [char](24) NOT NULL,
	[OthDirVarAcct] [char](10) NOT NULL,
	[OthDirVarSub] [char](24) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PerRetDoc] [smallint] NOT NULL,
	[RetObsComp] [smallint] NOT NULL,
	[RtgRptOpt] [smallint] NOT NULL,
	[RtgSeqAssign] [smallint] NOT NULL,
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
	[SetupID] [char](2) NOT NULL,
	[SiteBOM] [smallint] NOT NULL,
	[StdCstRevalAcct] [char](10) NOT NULL,
	[StdCstRevalSub] [char](24) NOT NULL,
	[SubTranCrt] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [AutoRef]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [BOMSeqAssign]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [CstRollOffVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [CstRollOffVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DecPlHrs]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltDirectLbrAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltDirectMtlAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltDirectOtherAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltOvhLbrFixedAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DfltOvhLbrFixedRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltOvhLbrVarAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DfltOvhLbrVarRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltOvhMachFixedAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DfltOvhMachFixedRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltOvhMachVarAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DfltOvhMachVarRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltOvhMtlFixedAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DfltOvhMtlFixedRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [DfltOvhMtlVarAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [DfltOvhMtlVarRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [GlbSiteID]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrACOvhSource]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrDirOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrDirOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrDirScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrDirScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrDirVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrDirVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhRatePct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LbrOvhVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [LowLevelFlag]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MachOvhOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MachOvhOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MachOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MachOvhScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MachOvhVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MachOvhVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlDirScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlDirScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlDirVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlDirVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhCalc]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhRatePct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MatlOvhVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [MCTypeBusFlg]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [OthDirOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [OthDirOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [OthDirScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [OthDirScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [OthDirVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [OthDirVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [PerRetDoc]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [RetObsComp]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [RtgRptOpt]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [RtgSeqAssign]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [SiteBOM]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [StdCstRevalAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [StdCstRevalSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [SubTranCrt]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BMSetup] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
