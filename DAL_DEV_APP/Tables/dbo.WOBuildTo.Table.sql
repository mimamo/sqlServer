USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[WOBuildTo]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOBuildTo](
	[Adjustment] [char](1) NOT NULL,
	[BuildToLineRef] [char](5) NOT NULL,
	[BuildToProj] [char](16) NOT NULL,
	[BuildToTask] [char](32) NOT NULL,
	[BuildToType] [char](3) NOT NULL,
	[BuildToWO] [char](16) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LSLineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[QtyComplete] [float] NOT NULL,
	[QtyCompleteOps] [float] NOT NULL,
	[QtyCurrent] [float] NOT NULL,
	[QtyOrig] [float] NOT NULL,
	[QtyQCHold] [float] NOT NULL,
	[QtyReDirect] [float] NOT NULL,
	[QtyRemaining] [float] NOT NULL,
	[QtyRework] [float] NOT NULL,
	[QtyReworkComp] [float] NOT NULL,
	[QtyScrap] [float] NOT NULL,
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
	[SiteID] [char](10) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[SrcLineNbr] [smallint] NOT NULL,
	[SrcLineRef] [char](5) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TargetDescr] [char](60) NOT NULL,
	[UnitDesc] [char](6) NOT NULL,
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
	[WONbr] [char](16) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_Adjustment]  DEFAULT (' ') FOR [Adjustment]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_BuildToLineRef]  DEFAULT (' ') FOR [BuildToLineRef]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_BuildToProj]  DEFAULT (' ') FOR [BuildToProj]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_BuildToTask]  DEFAULT (' ') FOR [BuildToTask]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_BuildToType]  DEFAULT (' ') FOR [BuildToType]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_BuildToWO]  DEFAULT (' ') FOR [BuildToWO]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_Crtd_Time]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LSLineCntr]  DEFAULT ((0)) FOR [LSLineCntr]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LUPd_Time]  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyComplete]  DEFAULT ((0)) FOR [QtyComplete]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyCompleteOps]  DEFAULT ((0)) FOR [QtyCompleteOps]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyCurrent]  DEFAULT ((0)) FOR [QtyCurrent]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyOrig]  DEFAULT ((0)) FOR [QtyOrig]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyQCHold]  DEFAULT ((0)) FOR [QtyQCHold]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyReDirect]  DEFAULT ((0)) FOR [QtyReDirect]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyRemaining]  DEFAULT ((0)) FOR [QtyRemaining]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyRework]  DEFAULT ((0)) FOR [QtyRework]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyReworkComp]  DEFAULT ((0)) FOR [QtyReworkComp]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_QtyScrap]  DEFAULT ((0)) FOR [QtyScrap]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_SrcLineNbr]  DEFAULT ((0)) FOR [SrcLineNbr]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_SrcLineRef]  DEFAULT (' ') FOR [SrcLineRef]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_TargetDescr]  DEFAULT (' ') FOR [TargetDescr]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_UnitDesc]  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User10]  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_User9]  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[WOBuildTo] ADD  CONSTRAINT [DF_WOBuildTo_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
