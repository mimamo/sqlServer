USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[RtgTran]    Script Date: 12/21/2015 16:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RtgTran](
	[ActLbrHrs] [float] NOT NULL,
	[ActMachHrs] [float] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CDirOthCst] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CrewSize] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CStdLbrHrs] [float] NOT NULL,
	[CStdMachHrs] [float] NOT NULL,
	[DeleteFlg] [smallint] NOT NULL,
	[DirLbrAmt] [float] NOT NULL,
	[DirLbrEffVarAmt] [float] NOT NULL,
	[DirLbrRateVarAmt] [float] NOT NULL,
	[DirOthAmt] [float] NOT NULL,
	[DirOthEffVarAmt] [float] NOT NULL,
	[DirOthRateVarAmt] [float] NOT NULL,
	[KitID] [char](30) NOT NULL,
	[LaborClassID] [char](10) NOT NULL,
	[LbrDirOffAcct] [char](10) NOT NULL,
	[LbrDirOffSub] [char](24) NOT NULL,
	[LbrDirVarAcct] [char](10) NOT NULL,
	[LbrDirVarSub] [char](24) NOT NULL,
	[LbrOvhOffAcct] [char](10) NOT NULL,
	[LbrOvhOffSub] [char](24) NOT NULL,
	[LbrOvhVarAcct] [char](10) NOT NULL,
	[LbrOvhVarSub] [char](24) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MachinID] [char](10) NOT NULL,
	[MachOvhOffAcct] [char](10) NOT NULL,
	[MachOvhOffSub] [char](24) NOT NULL,
	[MachOvhVarAcct] [char](10) NOT NULL,
	[MachOvhVarSub] [char](24) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OperationID] [char](10) NOT NULL,
	[OthDirOffAcct] [char](10) NOT NULL,
	[OthDirOffSub] [char](24) NOT NULL,
	[OthDirVarAcct] [char](10) NOT NULL,
	[OthDirVarSub] [char](24) NOT NULL,
	[OvhLbrAmt] [float] NOT NULL,
	[OvhLbrEffVarAmt] [float] NOT NULL,
	[OvhLbrRateVarAmt] [float] NOT NULL,
	[OvhMachAmt] [float] NOT NULL,
	[OvhMachEffVarAmt] [float] NOT NULL,
	[OvhMachRateVarAmt] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[RtgLineNbr] [smallint] NOT NULL,
	[RtgSiteID] [char](10) NOT NULL,
	[RtgStatus] [smallint] NOT NULL,
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
	[StepNbr] [char](5) NOT NULL,
	[ToolID1] [char](10) NOT NULL,
	[ToolID2] [char](10) NOT NULL,
	[ToolID3] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WorkCenterID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [ActLbrHrs]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [ActMachHrs]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [CDirOthCst]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [CrewSize]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [CStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [CStdMachHrs]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DeleteFlg]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DirLbrAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DirLbrEffVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DirLbrRateVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DirOthAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DirOthEffVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [DirOthRateVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LaborClassID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrDirOffAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrDirOffSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrDirVarAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrDirVarSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrOvhOffAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrOvhOffSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrOvhVarAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LbrOvhVarSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [MachinID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [MachOvhOffAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [MachOvhOffSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [MachOvhVarAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [MachOvhVarSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [OperationID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [OthDirOffAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [OthDirOffSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [OthDirVarAcct]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [OthDirVarSub]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [OvhLbrAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [OvhLbrEffVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [OvhLbrRateVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [OvhMachAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [OvhMachEffVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [OvhMachRateVarAmt]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [RtgLineNbr]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [RtgSiteID]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [RtgStatus]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [StepNbr]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [ToolID1]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [ToolID2]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [ToolID3]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[RtgTran] ADD  DEFAULT (' ') FOR [WorkCenterID]
GO
