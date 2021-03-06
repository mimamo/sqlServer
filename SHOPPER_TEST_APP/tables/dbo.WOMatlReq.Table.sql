USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[WOMatlReq]    Script Date: 12/21/2015 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOMatlReq](
	[CnvFact] [float] NOT NULL,
	[Comment] [char](30) NOT NULL,
	[CompAdded] [char](1) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateReqd] [smalldatetime] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LSLineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[QtyAutoIssuedPO] [float] NOT NULL,
	[QtyAutoIssuedWO] [float] NOT NULL,
	[QtyIssuedToDate] [float] NOT NULL,
	[QtyRemaining] [float] NOT NULL,
	[QtyScrapNoReAlloc] [float] NOT NULL,
	[QtyScrapReAlloc] [float] NOT NULL,
	[QtyStd] [float] NOT NULL,
	[QtyToIssue] [float] NOT NULL,
	[QtyTransferInWO] [float] NOT NULL,
	[QtyTransferOutNoReA] [float] NOT NULL,
	[QtyTransferOutReA] [float] NOT NULL,
	[QtyWOReqd] [float] NOT NULL,
	[RtgStep] [char](5) NOT NULL,
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
	[Sequence] [smallint] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[StockUsage] [char](1) NOT NULL,
	[Task] [char](32) NOT NULL,
	[UnitCost] [float] NOT NULL,
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
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [Comment]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [CompAdded]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [DateReqd]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [LSLineCntr]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyAutoIssuedPO]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyAutoIssuedWO]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyIssuedToDate]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyRemaining]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyScrapNoReAlloc]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyScrapReAlloc]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyStd]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyToIssue]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyTransferInWO]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyTransferOutNoReA]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyTransferOutReA]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [QtyWOReqd]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [RtgStep]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [StockUsage]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [Task]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[WOMatlReq] ADD  DEFAULT (' ') FOR [WONbr]
GO
