USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[BMSetup]    Script Date: 12/21/2015 13:43:57 ******/
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
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_AutoRef]  DEFAULT ((0)) FOR [AutoRef]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_BOMSeqAssign]  DEFAULT ((0)) FOR [BOMSeqAssign]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_CstRollOffVarAcct]  DEFAULT (' ') FOR [CstRollOffVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_CstRollOffVarSub]  DEFAULT (' ') FOR [CstRollOffVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DecPlHrs]  DEFAULT ((0)) FOR [DecPlHrs]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltDirectLbrAC]  DEFAULT (' ') FOR [DfltDirectLbrAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltDirectMtlAC]  DEFAULT (' ') FOR [DfltDirectMtlAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltDirectOtherAC]  DEFAULT (' ') FOR [DfltDirectOtherAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhLbrFixedAC]  DEFAULT (' ') FOR [DfltOvhLbrFixedAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhLbrFixedRate]  DEFAULT ((0)) FOR [DfltOvhLbrFixedRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhLbrVarAC]  DEFAULT (' ') FOR [DfltOvhLbrVarAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhLbrVarRate]  DEFAULT ((0)) FOR [DfltOvhLbrVarRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMachFixedAC]  DEFAULT (' ') FOR [DfltOvhMachFixedAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMachFixedRate]  DEFAULT ((0)) FOR [DfltOvhMachFixedRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMachVarAC]  DEFAULT (' ') FOR [DfltOvhMachVarAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMachVarRate]  DEFAULT ((0)) FOR [DfltOvhMachVarRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMtlFixedAC]  DEFAULT (' ') FOR [DfltOvhMtlFixedAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMtlFixedRate]  DEFAULT ((0)) FOR [DfltOvhMtlFixedRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMtlVarAC]  DEFAULT (' ') FOR [DfltOvhMtlVarAC]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_DfltOvhMtlVarRate]  DEFAULT ((0)) FOR [DfltOvhMtlVarRate]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_GlbSiteID]  DEFAULT (' ') FOR [GlbSiteID]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LastRefNbr]  DEFAULT (' ') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrACOvhSource]  DEFAULT (' ') FOR [LbrACOvhSource]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrDirOffAcct]  DEFAULT (' ') FOR [LbrDirOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrDirOffSub]  DEFAULT (' ') FOR [LbrDirOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrDirScrapVarAcct]  DEFAULT (' ') FOR [LbrDirScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrDirScrapVarSub]  DEFAULT (' ') FOR [LbrDirScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrDirVarAcct]  DEFAULT (' ') FOR [LbrDirVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrDirVarSub]  DEFAULT (' ') FOR [LbrDirVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhOffAcct]  DEFAULT (' ') FOR [LbrOvhOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhOffSub]  DEFAULT (' ') FOR [LbrOvhOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhRatePct]  DEFAULT (' ') FOR [LbrOvhRatePct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhScrapVarAcct]  DEFAULT (' ') FOR [LbrOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhScrapVarSub]  DEFAULT (' ') FOR [LbrOvhScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhVarAcct]  DEFAULT (' ') FOR [LbrOvhVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LbrOvhVarSub]  DEFAULT (' ') FOR [LbrOvhVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LowLevelFlag]  DEFAULT ((0)) FOR [LowLevelFlag]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MachOvhOffAcct]  DEFAULT (' ') FOR [MachOvhOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MachOvhOffSub]  DEFAULT (' ') FOR [MachOvhOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MachOvhScrapVarAcct]  DEFAULT (' ') FOR [MachOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MachOvhScrapVarSub]  DEFAULT (' ') FOR [MachOvhScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MachOvhVarAcct]  DEFAULT (' ') FOR [MachOvhVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MachOvhVarSub]  DEFAULT (' ') FOR [MachOvhVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlDirScrapVarAcct]  DEFAULT (' ') FOR [MatlDirScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlDirScrapVarSub]  DEFAULT (' ') FOR [MatlDirScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlDirVarAcct]  DEFAULT (' ') FOR [MatlDirVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlDirVarSub]  DEFAULT (' ') FOR [MatlDirVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhCalc]  DEFAULT (' ') FOR [MatlOvhCalc]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhOffAcct]  DEFAULT (' ') FOR [MatlOvhOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhOffSub]  DEFAULT (' ') FOR [MatlOvhOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhRatePct]  DEFAULT (' ') FOR [MatlOvhRatePct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhScrapVarAcct]  DEFAULT (' ') FOR [MatlOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhScrapVarSub]  DEFAULT (' ') FOR [MatlOvhScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhVarAcct]  DEFAULT (' ') FOR [MatlOvhVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MatlOvhVarSub]  DEFAULT (' ') FOR [MatlOvhVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_MCTypeBusFlg]  DEFAULT (' ') FOR [MCTypeBusFlg]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_OthDirOffAcct]  DEFAULT (' ') FOR [OthDirOffAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_OthDirOffSub]  DEFAULT (' ') FOR [OthDirOffSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_OthDirScrapVarAcct]  DEFAULT (' ') FOR [OthDirScrapVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_OthDirScrapVarSub]  DEFAULT (' ') FOR [OthDirScrapVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_OthDirVarAcct]  DEFAULT (' ') FOR [OthDirVarAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_OthDirVarSub]  DEFAULT (' ') FOR [OthDirVarSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_PerNbr]  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_PerRetDoc]  DEFAULT ((0)) FOR [PerRetDoc]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_RetObsComp]  DEFAULT ((0)) FOR [RetObsComp]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_RtgRptOpt]  DEFAULT ((0)) FOR [RtgRptOpt]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_RtgSeqAssign]  DEFAULT ((0)) FOR [RtgSeqAssign]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_SetupID]  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_SiteBOM]  DEFAULT ((0)) FOR [SiteBOM]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_StdCstRevalAcct]  DEFAULT (' ') FOR [StdCstRevalAcct]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_StdCstRevalSub]  DEFAULT (' ') FOR [StdCstRevalSub]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_SubTranCrt]  DEFAULT ((0)) FOR [SubTranCrt]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BMSetup] ADD  CONSTRAINT [DF_BMSetup_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
