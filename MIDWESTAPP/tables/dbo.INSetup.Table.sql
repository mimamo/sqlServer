USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[INSetup]    Script Date: 12/21/2015 15:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[INSetup](
	[ActivateLang] [smallint] NOT NULL,
	[AdjustmentsAcct] [char](10) NOT NULL,
	[AdjustmentsSub] [char](24) NOT NULL,
	[AllowCostEntry] [smallint] NOT NULL,
	[APClearingAcct] [char](10) NOT NULL,
	[APClearingSub] [char](24) NOT NULL,
	[ARClearingAcct] [char](10) NOT NULL,
	[ARClearingSub] [char](24) NOT NULL,
	[AutoAdjustEntry] [smallint] NOT NULL,
	[AutoBatRpt] [smallint] NOT NULL,
	[AutoRelease] [char](1) NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIDfltRtTp] [char](6) NOT NULL,
	[BMIEnabled] [smallint] NOT NULL,
	[CPSOnOff] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrPerNbr] [char](6) NOT NULL,
	[DecPlPrcCst] [smallint] NOT NULL,
	[DecPlQty] [smallint] NOT NULL,
	[DfltChkOrdQty] [char](1) NOT NULL,
	[DfltCOGSAcct] [char](10) NOT NULL,
	[DfltCOGSSub] [char](24) NOT NULL,
	[DfltDIscPrc] [char](1) NOT NULL,
	[DfltInvtAcct] [char](10) NOT NULL,
	[DfltInvtLeadTime] [float] NOT NULL,
	[DfltInvtMfgLeadTime] [float] NOT NULL,
	[DfltInvtSub] [char](24) NOT NULL,
	[DfltInvtType] [char](1) NOT NULL,
	[DfltItmSiteAcct] [char](10) NOT NULL,
	[DfltLCVarianceAcct] [char](10) NOT NULL,
	[DfltLCVarianceSub] [char](24) NOT NULL,
	[DfltLotAssign] [char](1) NOT NULL,
	[DfltlotFxdLen] [smallint] NOT NULL,
	[DfltLotFxdTyp] [char](1) NOT NULL,
	[DfltLotFxdVal] [char](12) NOT NULL,
	[DfltLotMthd] [char](1) NOT NULL,
	[DfltLotNumLen] [smallint] NOT NULL,
	[DfltLotNumVal] [char](25) NOT NULL,
	[DfltLotSerTrack] [char](1) NOT NULL,
	[DfltLotShelfLife] [smallint] NOT NULL,
	[DfltPhysQty] [smallint] NOT NULL,
	[DfltPPVAcct] [char](10) NOT NULL,
	[DfltPPVSub] [char](24) NOT NULL,
	[DfltProdClass] [char](6) NOT NULL,
	[DfltSalesAcct] [char](10) NOT NULL,
	[DfltSalesSub] [char](24) NOT NULL,
	[DfltSerAssign] [char](1) NOT NULL,
	[DfltSerFxdLen] [smallint] NOT NULL,
	[DfltSerFxdTyp] [char](1) NOT NULL,
	[DfltSerFxdVal] [char](12) NOT NULL,
	[DfltSerMethod] [char](1) NOT NULL,
	[DfltSerNumLen] [smallint] NOT NULL,
	[DfltSerNumVal] [char](25) NOT NULL,
	[DfltSerShelfLife] [smallint] NOT NULL,
	[DfltShpnotInvAcct] [char](10) NOT NULL,
	[DfltShpnotInvSub] [char](24) NOT NULL,
	[DfltSite] [char](10) NOT NULL,
	[DfltSlsTaxCat] [char](10) NOT NULL,
	[DfltSource] [char](1) NOT NULL,
	[DfltStatus] [char](1) NOT NULL,
	[DfltStatusQtyZero] [char](1) NOT NULL,
	[DfltStkItem] [smallint] NOT NULL,
	[DfltValMthd] [char](1) NOT NULL,
	[DfltVarAcct] [char](10) NOT NULL,
	[DfltVarSub] [char](24) NOT NULL,
	[ExplInvoice] [smallint] NOT NULL,
	[ExplOrder] [smallint] NOT NULL,
	[ExplPackSlip] [smallint] NOT NULL,
	[ExplPickList] [smallint] NOT NULL,
	[ExplShipping] [smallint] NOT NULL,
	[ExprdLotNbrs] [smallint] NOT NULL,
	[ExprdSerNbrs] [smallint] NOT NULL,
	[GLPostOpt] [char](1) NOT NULL,
	[InclAllocQty] [smallint] NOT NULL,
	[INClearingAcct] [char](10) NOT NULL,
	[INClearingSub] [char](24) NOT NULL,
	[InclQtyAllocWO] [smallint] NOT NULL,
	[InclQtyCustOrd] [smallint] NOT NULL,
	[InclQtyInTransit] [smallint] NOT NULL,
	[InclQtyOnBO] [smallint] NOT NULL,
	[InclQtyOnPO] [smallint] NOT NULL,
	[InclQtyOnWO] [smallint] NOT NULL,
	[InclWOFirmDemand] [smallint] NOT NULL,
	[InclWOFirmSupply] [smallint] NOT NULL,
	[InclWORlsedDemand] [smallint] NOT NULL,
	[InclWORlsedSupply] [smallint] NOT NULL,
	[Init] [smallint] NOT NULL,
	[InTransitAcct] [char](10) NOT NULL,
	[InTransitSub] [char](24) NOT NULL,
	[IssuesAcct] [char](10) NOT NULL,
	[IssuesSub] [char](24) NOT NULL,
	[LanguageID] [char](4) NOT NULL,
	[LastArchiveDate] [smalldatetime] NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LastCountDate] [smalldatetime] NOT NULL,
	[LastTagNbr] [int] NOT NULL,
	[LotSerRetHist] [smallint] NOT NULL,
	[LstSlsPrcID] [char](10) NOT NULL,
	[LstTrnsfrDocNbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[MatlOvhCalc] [char](1) NOT NULL,
	[MatlOvhOffAcct] [char](10) NOT NULL,
	[MatlOvhOffSub] [char](24) NOT NULL,
	[MatlOvhRatePct] [char](1) NOT NULL,
	[MatlOvhVarAcct] [char](10) NOT NULL,
	[MatlOvhVarSub] [char](24) NOT NULL,
	[MfgClassID] [char](10) NOT NULL,
	[MinGrossProfit] [float] NOT NULL,
	[MultWhse] [smallint] NOT NULL,
	[NbrCounts] [smallint] NOT NULL,
	[NbrCycleCounts] [smallint] NOT NULL,
	[NegQty] [smallint] NOT NULL,
	[NonKitAssy] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OverSoldCostLayers] [smallint] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PerRetPITrans] [smallint] NOT NULL,
	[PerRetTran] [smallint] NOT NULL,
	[PhysAdjVarAcct] [char](10) NOT NULL,
	[PhysAdjVarSub] [char](24) NOT NULL,
	[PIABC] [char](1) NOT NULL,
	[PMAvail] [smallint] NOT NULL,
	[RollBackBatches] [smallint] NOT NULL,
	[RollupCost] [smallint] NOT NULL,
	[RollupPrice] [smallint] NOT NULL,
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
	[SerAssign] [char](1) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SpecChar] [char](24) NOT NULL,
	[StdCstRevalAcct] [char](10) NOT NULL,
	[StdCstRevalSub] [char](24) NOT NULL,
	[TableBypass] [smallint] NOT NULL,
	[Tagged] [smallint] NOT NULL,
	[TranCOGSSub] [char](1) NOT NULL,
	[UpdateGL] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VolUnit] [char](6) NOT NULL,
	[WhseLocValid] [char](1) NOT NULL,
	[WtUnit] [char](6) NOT NULL,
	[YrsRetArchTran] [smallint] NOT NULL,
	[YrsRetHist] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [INSetup0] PRIMARY KEY CLUSTERED 
(
	[SetupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ActivateLang]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [AdjustmentsAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [AdjustmentsSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [AllowCostEntry]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [APClearingAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [APClearingSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [ARClearingAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [ARClearingSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [AutoAdjustEntry]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [AutoBatRpt]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [AutoRelease]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [BMIDfltRtTp]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [BMIEnabled]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [CPSOnOff]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [CurrPerNbr]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DecPlPrcCst]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DecPlQty]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltChkOrdQty]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltCOGSAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltCOGSSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltDIscPrc]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltInvtAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltInvtLeadTime]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltInvtMfgLeadTime]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltInvtSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltInvtType]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltItmSiteAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLCVarianceAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLCVarianceSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLotAssign]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltlotFxdLen]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLotFxdTyp]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLotFxdVal]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLotMthd]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltLotNumLen]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLotNumVal]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltLotSerTrack]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltLotShelfLife]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltPhysQty]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltPPVAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltPPVSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltProdClass]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSalesAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSalesSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSerAssign]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltSerFxdLen]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSerFxdTyp]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSerFxdVal]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSerMethod]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltSerNumLen]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSerNumVal]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltSerShelfLife]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltShpnotInvAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltShpnotInvSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSite]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSlsTaxCat]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltSource]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltStatus]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltStatusQtyZero]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [DfltStkItem]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltValMthd]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltVarAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [DfltVarSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExplInvoice]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExplOrder]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExplPackSlip]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExplPickList]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExplShipping]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExprdLotNbrs]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [ExprdSerNbrs]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [GLPostOpt]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclAllocQty]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [INClearingAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [INClearingSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclQtyAllocWO]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclQtyCustOrd]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclQtyInTransit]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclQtyOnBO]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclQtyOnPO]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclQtyOnWO]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclWOFirmDemand]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclWOFirmSupply]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclWORlsedDemand]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [InclWORlsedSupply]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [Init]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [InTransitAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [InTransitSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [IssuesAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [IssuesSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [LanguageID]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [LastArchiveDate]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [LastBatNbr]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [LastCountDate]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [LastTagNbr]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [LotSerRetHist]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [LstSlsPrcID]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [LstTrnsfrDocNbr]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MatlOvhCalc]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MatlOvhOffAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MatlOvhOffSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MatlOvhRatePct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MatlOvhVarAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MatlOvhVarSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [MfgClassID]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [MinGrossProfit]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [MultWhse]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [NbrCounts]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [NbrCycleCounts]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [NegQty]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [NonKitAssy]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [OverSoldCostLayers]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [PerRetPITrans]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [PerRetTran]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [PhysAdjVarAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [PhysAdjVarSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [PIABC]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [PMAvail]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [RollBackBatches]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [RollupCost]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [RollupPrice]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [SerAssign]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [SetupId]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [SpecChar]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [StdCstRevalAcct]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [StdCstRevalSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [TableBypass]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [Tagged]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [TranCOGSSub]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [UpdateGL]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [VolUnit]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [WhseLocValid]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT (' ') FOR [WtUnit]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [YrsRetArchTran]
GO
ALTER TABLE [dbo].[INSetup] ADD  DEFAULT ((0)) FOR [YrsRetHist]
GO
