USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[WorkCenter]    Script Date: 12/21/2015 14:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WorkCenter](
	[CpnyID] [char](10) NOT NULL,
	[CrewSize] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DirectLaborAC] [char](16) NOT NULL,
	[DirectMtlAC] [char](16) NOT NULL,
	[DirectOtherAC] [char](16) NOT NULL,
	[LbrDirOffAcct] [char](10) NOT NULL,
	[LbrDirOffSub] [char](24) NOT NULL,
	[LbrDirScrapVarAcct] [char](10) NOT NULL,
	[LbrDirScrapVarSub] [char](24) NOT NULL,
	[LbrDirVarAcct] [char](10) NOT NULL,
	[LbrDirVarSub] [char](24) NOT NULL,
	[LbrOvhOffAcct] [char](10) NOT NULL,
	[LbrOvhOffSub] [char](24) NOT NULL,
	[LbrOvhScrapVarAcct] [char](10) NOT NULL,
	[LbrOvhScrapVarSub] [char](24) NOT NULL,
	[LbrOvhVarAcct] [char](10) NOT NULL,
	[LbrOvhVarSub] [char](24) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MachOvhOffAcct] [char](10) NOT NULL,
	[MachOvhOffSub] [char](24) NOT NULL,
	[MachOvhScrapVarAcct] [char](10) NOT NULL,
	[MachOvhScrapVarSub] [char](24) NOT NULL,
	[MachOvhVarAcct] [char](10) NOT NULL,
	[MachOvhVarSub] [char](24) NOT NULL,
	[NbrMachines] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OthDirOffAcct] [char](10) NOT NULL,
	[OthDirOffSub] [char](24) NOT NULL,
	[OthDirScrapVarAcct] [char](10) NOT NULL,
	[OthDirScrapVarSub] [char](24) NOT NULL,
	[OthDirVarAcct] [char](10) NOT NULL,
	[OthDirVarSub] [char](24) NOT NULL,
	[OvhLaborFixedAC] [char](16) NOT NULL,
	[OvhLaborVarAC] [char](16) NOT NULL,
	[OvhMachFixedAC] [char](16) NOT NULL,
	[OvhMachVarAC] [char](16) NOT NULL,
	[OvhMtlFixedAC] [char](16) NOT NULL,
	[OvhMtlVarAC] [char](16) NOT NULL,
	[PFLbrOvhRate] [float] NOT NULL,
	[PFMachOvhRate] [float] NOT NULL,
	[PLbrOvhRate] [float] NOT NULL,
	[PMachOvhRate] [float] NOT NULL,
	[PVLbrOvhRate] [float] NOT NULL,
	[PVMachOvhRate] [float] NOT NULL,
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
	[SFLbrOvhRate] [float] NOT NULL,
	[SFMachOvhRate] [float] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SLbrOvhRate] [float] NOT NULL,
	[SMachOvhRate] [float] NOT NULL,
	[SVLbrOvhRate] [float] NOT NULL,
	[SVMachOvhRate] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WorkCenterID] [char](10) NOT NULL,
	[WorkHrs] [float] NOT NULL,
	[WrkComp] [char](6) NOT NULL,
	[WrkLoc] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [CrewSize]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [DirectLaborAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [DirectMtlAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [DirectOtherAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrDirOffAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrDirOffSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrDirScrapVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrDirScrapVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrDirVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrDirVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrOvhOffAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrOvhOffSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrOvhScrapVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrOvhVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LbrOvhVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [MachOvhOffAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [MachOvhOffSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [MachOvhScrapVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [MachOvhScrapVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [MachOvhVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [MachOvhVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [NbrMachines]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OthDirOffAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OthDirOffSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OthDirScrapVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OthDirScrapVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OthDirVarAcct]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OthDirVarSub]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OvhLaborFixedAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OvhLaborVarAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OvhMachFixedAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OvhMachVarAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OvhMtlFixedAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [OvhMtlVarAC]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [PFLbrOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [PFMachOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [PLbrOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [PMachOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [PVLbrOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [PVMachOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [SFLbrOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [SFMachOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [SLbrOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [SMachOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [SVLbrOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [SVMachOvhRate]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [WorkCenterID]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT ((0)) FOR [WorkHrs]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [WrkComp]
GO
ALTER TABLE [dbo].[WorkCenter] ADD  DEFAULT (' ') FOR [WrkLoc]
GO
