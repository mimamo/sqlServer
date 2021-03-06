USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[BOMDoc]    Script Date: 12/21/2015 15:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BOMDoc](
	[AssyQty] [float] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BOMSiteID] [char](10) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DirLbrAmt] [float] NOT NULL,
	[DirMatlAmt] [float] NOT NULL,
	[DirOthAmt] [float] NOT NULL,
	[DocType] [char](1) NOT NULL,
	[EffLbrOvhVarAmt] [float] NOT NULL,
	[EffLbrVarAmt] [float] NOT NULL,
	[EffMachOvhVarAmt] [float] NOT NULL,
	[EffMatlOvhVarAmt] [float] NOT NULL,
	[EffMatlVarAmt] [float] NOT NULL,
	[EffOthVarAmt] [float] NOT NULL,
	[InBal] [char](1) NOT NULL,
	[KitCntr] [float] NOT NULL,
	[KitID] [char](30) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MCActivated] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigRefNbr] [char](10) NOT NULL,
	[OvhLbrAmt] [float] NOT NULL,
	[OvhMachAmt] [float] NOT NULL,
	[OvhMatlAmt] [float] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PlanID] [char](6) NOT NULL,
	[ProductionQuantity] [float] NOT NULL,
	[ProductionUnit] [char](6) NOT NULL,
	[RateLbrOvhVarAmt] [float] NOT NULL,
	[RateLbrVarAmt] [float] NOT NULL,
	[RateMachOvhVarAmt] [float] NOT NULL,
	[RateMatlOvhVarAmt] [float] NOT NULL,
	[RateMatlVarAmt] [float] NOT NULL,
	[RateOthVarAmt] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Rlsed] [smallint] NOT NULL,
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
	[Status] [char](1) NOT NULL,
	[StockUsage] [char](1) NOT NULL,
	[TotTranAmt] [float] NOT NULL,
	[TotVarAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranType] [char](2) NOT NULL,
	[UnitMultDiv] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [AssyQty]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [BOMSiteID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [DirLbrAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [DirMatlAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [DirOthAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [DocType]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [EffLbrOvhVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [EffLbrVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [EffMachOvhVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [EffMatlOvhVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [EffMatlVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [EffOthVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [InBal]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [KitCntr]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [MCActivated]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [OrigRefNbr]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [OvhLbrAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [OvhMachAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [OvhMatlAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [PlanID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [ProductionQuantity]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [ProductionUnit]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [RateLbrOvhVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [RateLbrVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [RateMachOvhVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [RateMatlOvhVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [RateMatlVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [RateOthVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [StockUsage]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [TotTranAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [TotVarAmt]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[BOMDoc] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
