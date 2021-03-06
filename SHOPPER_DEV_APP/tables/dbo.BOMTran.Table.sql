USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[BOMTran]    Script Date: 12/21/2015 14:33:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BOMTran](
	[AssyQty] [float] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BOMLevel] [smallint] NOT NULL,
	[BOMLineNbr] [smallint] NOT NULL,
	[BOMQty] [float] NOT NULL,
	[BOMSiteID] [char](10) NOT NULL,
	[CmpnentID] [char](30) NOT NULL,
	[CmpnentQty] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeleteFlag] [smallint] NOT NULL,
	[DirAssyAmt] [float] NOT NULL,
	[DirCmpnentAmt] [float] NOT NULL,
	[DirEffVarAmt] [float] NOT NULL,
	[DirRateVarAmt] [float] NOT NULL,
	[KitID] [char](30) NOT NULL,
	[KitSiteID] [char](10) NOT NULL,
	[KitStatus] [char](1) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerCntr] [smallint] NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MCActivated] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OvhAssyAmt] [float] NOT NULL,
	[OvhCmpnentAmt] [float] NOT NULL,
	[OvhEffVarAmt] [float] NOT NULL,
	[OvhRateVarAmt] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
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
	[Sequence] [char](5) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StdQty] [float] NOT NULL,
	[StockUsage] [char](1) NOT NULL,
	[SubKitStatus] [char](1) NOT NULL,
	[TotAssyAmt] [float] NOT NULL,
	[TotCmpnentAmt] [float] NOT NULL,
	[TotEffVarAmt] [float] NOT NULL,
	[TotRateVarAmt] [float] NOT NULL,
	[TotVarAmt] [float] NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranType] [char](2) NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [AssyQty]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [BOMLevel]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [BOMLineNbr]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [BOMQty]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [BOMSiteID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [CmpnentID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [CmpnentQty]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [DeleteFlag]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [DirAssyAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [DirCmpnentAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [DirEffVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [DirRateVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [KitSiteID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [KitStatus]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [LotSerCntr]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [MCActivated]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [OvhAssyAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [OvhCmpnentAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [OvhEffVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [OvhRateVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [Sequence]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [StdQty]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [StockUsage]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [SubKitStatus]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [TotAssyAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [TotCmpnentAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [TotEffVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [TotRateVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [TotVarAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[BOMTran] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
