USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 12/21/2015 13:35:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Inventory](
	[ABCCode] [char](2) NOT NULL,
	[ApprovedVendor] [smallint] NOT NULL,
	[AutoPODropShip] [smallint] NOT NULL,
	[AutoPOPolicy] [char](2) NOT NULL,
	[BMIDirStdCost] [float] NOT NULL,
	[BMIFOvhStdCost] [float] NOT NULL,
	[BMILastCost] [float] NOT NULL,
	[BMIPDirStdCost] [float] NOT NULL,
	[BMIPFOvhStdCost] [float] NOT NULL,
	[BMIPStdCost] [float] NOT NULL,
	[BMIPVOvhStdCost] [float] NOT NULL,
	[BMIStdCost] [float] NOT NULL,
	[BMIVOvhStdCost] [float] NOT NULL,
	[BOLCode] [char](10) NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[ChkOrdQty] [char](1) NOT NULL,
	[ClassID] [char](6) NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](24) NOT NULL,
	[Color] [char](20) NOT NULL,
	[CountStatus] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryListPrice] [float] NOT NULL,
	[CuryMinPrice] [float] NOT NULL,
	[CustomFtr] [smallint] NOT NULL,
	[CycleID] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[DfltPickLoc] [char](10) NOT NULL,
	[DfltPOUnit] [char](6) NOT NULL,
	[DfltSalesAcct] [char](10) NOT NULL,
	[DfltSalesSub] [char](24) NOT NULL,
	[DfltShpnotInvAcct] [char](10) NOT NULL,
	[DfltShpnotInvSub] [char](24) NOT NULL,
	[DfltSite] [char](10) NOT NULL,
	[DfltSOUnit] [char](6) NOT NULL,
	[DfltWhseLoc] [char](10) NOT NULL,
	[DirStdCost] [float] NOT NULL,
	[DiscAcct] [char](10) NOT NULL,
	[DiscPrc] [char](1) NOT NULL,
	[DiscSub] [char](31) NOT NULL,
	[EOQ] [float] NOT NULL,
	[ExplInvoice] [smallint] NOT NULL,
	[ExplOrder] [smallint] NOT NULL,
	[ExplPackSlip] [smallint] NOT NULL,
	[ExplPickList] [smallint] NOT NULL,
	[ExplShipping] [smallint] NOT NULL,
	[FOvhStdCost] [float] NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtSub] [char](24) NOT NULL,
	[GLClassID] [char](4) NOT NULL,
	[InvtAcct] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[InvtSub] [char](24) NOT NULL,
	[InvtType] [char](1) NOT NULL,
	[IRCalcPolicy] [char](1) NOT NULL,
	[IRDaysSupply] [float] NOT NULL,
	[IRDemandID] [char](10) NOT NULL,
	[IRFutureDate] [smalldatetime] NOT NULL,
	[IRFuturePolicy] [char](1) NOT NULL,
	[IRLeadTimeID] [char](10) NOT NULL,
	[IRLinePtQty] [float] NOT NULL,
	[IRMinOnHand] [float] NOT NULL,
	[IRModelInvtID] [char](30) NOT NULL,
	[IRRCycDays] [smallint] NOT NULL,
	[IRSeasonEndDay] [smallint] NOT NULL,
	[IRSeasonEndMon] [smallint] NOT NULL,
	[IRSeasonStrtDay] [smallint] NOT NULL,
	[IRSeasonStrtMon] [smallint] NOT NULL,
	[IRServiceLevel] [float] NOT NULL,
	[IRSftyStkDays] [float] NOT NULL,
	[IRSftyStkPct] [float] NOT NULL,
	[IRSftyStkPolicy] [char](1) NOT NULL,
	[IRSourceCode] [char](1) NOT NULL,
	[IRTargetOrdMethod] [char](1) NOT NULL,
	[IRTargetOrdReq] [float] NOT NULL,
	[IRTransferSiteID] [char](10) NOT NULL,
	[ItemCommClassID] [char](10) NOT NULL,
	[Kit] [smallint] NOT NULL,
	[LastBookQty] [float] NOT NULL,
	[LastCost] [float] NOT NULL,
	[LastCountDate] [smalldatetime] NOT NULL,
	[LastSiteID] [char](10) NOT NULL,
	[LastStdCost] [float] NOT NULL,
	[LastVarAmt] [float] NOT NULL,
	[LastVarPct] [float] NOT NULL,
	[LastVarQty] [float] NOT NULL,
	[LCVarianceAcct] [char](10) NOT NULL,
	[LCVarianceSub] [char](24) NOT NULL,
	[LeadTime] [float] NOT NULL,
	[LinkSpecId] [smallint] NOT NULL,
	[LotSerFxdLen] [smallint] NOT NULL,
	[LotSerFxdTyp] [char](1) NOT NULL,
	[LotSerFxdVal] [char](12) NOT NULL,
	[LotSerIssMthd] [char](1) NOT NULL,
	[LotSerNumLen] [smallint] NOT NULL,
	[LotSerNumVal] [char](25) NOT NULL,
	[LotSerTrack] [char](2) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[MaxOnHand] [float] NOT NULL,
	[MfgClassID] [char](10) NOT NULL,
	[MfgLeadTime] [float] NOT NULL,
	[MinGrossProfit] [float] NOT NULL,
	[MoveClass] [char](10) NOT NULL,
	[MSDS] [char](24) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Pack] [char](6) NOT NULL,
	[PDirStdCost] [float] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PFOvhStdCost] [float] NOT NULL,
	[PPVAcct] [char](10) NOT NULL,
	[PPVSub] [char](24) NOT NULL,
	[PriceClassID] [char](6) NOT NULL,
	[ProdMgrID] [char](10) NOT NULL,
	[ProductionUnit] [char](6) NOT NULL,
	[PStdCost] [float] NOT NULL,
	[PStdCostDate] [smalldatetime] NOT NULL,
	[PVOvhStdCost] [float] NOT NULL,
	[ReordPt] [float] NOT NULL,
	[ReOrdPtCalc] [float] NOT NULL,
	[ReordQty] [float] NOT NULL,
	[ReOrdQtyCalc] [float] NOT NULL,
	[ReplMthd] [char](1) NOT NULL,
	[RollupCost] [smallint] NOT NULL,
	[RollupPrice] [smallint] NOT NULL,
	[RvsdPrc] [smallint] NOT NULL,
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
	[S4Future13] [char](10) NOT NULL,
	[SafetyStk] [float] NOT NULL,
	[SafetyStkCalc] [float] NOT NULL,
	[Selected] [smallint] NOT NULL,
	[SerAssign] [char](1) NOT NULL,
	[Service] [smallint] NOT NULL,
	[ShelfLife] [smallint] NOT NULL,
	[Size] [char](10) NOT NULL,
	[Source] [char](1) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StdCost] [float] NOT NULL,
	[StdCostDate] [smalldatetime] NOT NULL,
	[StkBasePrc] [float] NOT NULL,
	[StkItem] [smallint] NOT NULL,
	[StkRvsdPrc] [float] NOT NULL,
	[StkTaxBasisPrc] [float] NOT NULL,
	[StkUnit] [char](6) NOT NULL,
	[StkVol] [float] NOT NULL,
	[StkWt] [float] NOT NULL,
	[StkWtUnit] [char](6) NOT NULL,
	[Style] [char](10) NOT NULL,
	[Supplr1] [char](15) NOT NULL,
	[Supplr2] [char](15) NOT NULL,
	[SupplrItem1] [char](20) NOT NULL,
	[SupplrItem2] [char](20) NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TranStatusCode] [char](2) NOT NULL,
	[Turns] [float] NOT NULL,
	[UPCCode] [char](30) NOT NULL,
	[UsageRate] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[ValMthd] [char](1) NOT NULL,
	[VOvhStdCost] [float] NOT NULL,
	[WarrantyDays] [smallint] NOT NULL,
	[YTDUsage] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Inventory0] PRIMARY KEY CLUSTERED 
(
	[InvtID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ABCCode]  DEFAULT (' ') FOR [ABCCode]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ApprovedVendor]  DEFAULT ((0)) FOR [ApprovedVendor]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_AutoPODropShip]  DEFAULT ((0)) FOR [AutoPODropShip]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_AutoPOPolicy]  DEFAULT (' ') FOR [AutoPOPolicy]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIDirStdCost]  DEFAULT ((0)) FOR [BMIDirStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIFOvhStdCost]  DEFAULT ((0)) FOR [BMIFOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMILastCost]  DEFAULT ((0)) FOR [BMILastCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIPDirStdCost]  DEFAULT ((0)) FOR [BMIPDirStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIPFOvhStdCost]  DEFAULT ((0)) FOR [BMIPFOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIPStdCost]  DEFAULT ((0)) FOR [BMIPStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIPVOvhStdCost]  DEFAULT ((0)) FOR [BMIPVOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIStdCost]  DEFAULT ((0)) FOR [BMIStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BMIVOvhStdCost]  DEFAULT ((0)) FOR [BMIVOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_BOLCode]  DEFAULT (' ') FOR [BOLCode]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ChkOrdQty]  DEFAULT (' ') FOR [ChkOrdQty]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ClassID]  DEFAULT (' ') FOR [ClassID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_COGSAcct]  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_COGSSub]  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Color]  DEFAULT (' ') FOR [Color]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_CountStatus]  DEFAULT ('A') FOR [CountStatus]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_CuryListPrice]  DEFAULT ((0)) FOR [CuryListPrice]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_CuryMinPrice]  DEFAULT ((0)) FOR [CuryMinPrice]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_CustomFtr]  DEFAULT ((0)) FOR [CustomFtr]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_CycleID]  DEFAULT (' ') FOR [CycleID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltPickLoc]  DEFAULT (' ') FOR [DfltPickLoc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltPOUnit]  DEFAULT (' ') FOR [DfltPOUnit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltSalesAcct]  DEFAULT (' ') FOR [DfltSalesAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltSalesSub]  DEFAULT (' ') FOR [DfltSalesSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltShpnotInvAcct]  DEFAULT (' ') FOR [DfltShpnotInvAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltShpnotInvSub]  DEFAULT (' ') FOR [DfltShpnotInvSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltSite]  DEFAULT (' ') FOR [DfltSite]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltSOUnit]  DEFAULT (' ') FOR [DfltSOUnit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DfltWhseLoc]  DEFAULT (' ') FOR [DfltWhseLoc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DirStdCost]  DEFAULT ((0)) FOR [DirStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DiscAcct]  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DiscPrc]  DEFAULT (' ') FOR [DiscPrc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_DiscSub]  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_EOQ]  DEFAULT ((0)) FOR [EOQ]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ExplInvoice]  DEFAULT ((0)) FOR [ExplInvoice]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ExplOrder]  DEFAULT ((0)) FOR [ExplOrder]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ExplPackSlip]  DEFAULT ((0)) FOR [ExplPackSlip]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ExplPickList]  DEFAULT ((0)) FOR [ExplPickList]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ExplShipping]  DEFAULT ((0)) FOR [ExplShipping]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_FOvhStdCost]  DEFAULT ((0)) FOR [FOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_FrtAcct]  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_FrtSub]  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_GLClassID]  DEFAULT (' ') FOR [GLClassID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_InvtAcct]  DEFAULT (' ') FOR [InvtAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_InvtSub]  DEFAULT (' ') FOR [InvtSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_InvtType]  DEFAULT (' ') FOR [InvtType]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRCalcPolicy]  DEFAULT (' ') FOR [IRCalcPolicy]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRDaysSupply]  DEFAULT ((0)) FOR [IRDaysSupply]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRDemandID]  DEFAULT (' ') FOR [IRDemandID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRFutureDate]  DEFAULT ('01/01/1900') FOR [IRFutureDate]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRFuturePolicy]  DEFAULT (' ') FOR [IRFuturePolicy]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRLeadTimeID]  DEFAULT (' ') FOR [IRLeadTimeID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRLinePtQty]  DEFAULT ((0)) FOR [IRLinePtQty]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRMinOnHand]  DEFAULT ((0)) FOR [IRMinOnHand]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRModelInvtID]  DEFAULT (' ') FOR [IRModelInvtID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRRCycDays]  DEFAULT ((0)) FOR [IRRCycDays]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSeasonEndDay]  DEFAULT ((0)) FOR [IRSeasonEndDay]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSeasonEndMon]  DEFAULT ((0)) FOR [IRSeasonEndMon]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSeasonStrtDay]  DEFAULT ((0)) FOR [IRSeasonStrtDay]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSeasonStrtMon]  DEFAULT ((0)) FOR [IRSeasonStrtMon]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRServiceLevel]  DEFAULT ((0)) FOR [IRServiceLevel]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSftyStkDays]  DEFAULT ((0)) FOR [IRSftyStkDays]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSftyStkPct]  DEFAULT ((0)) FOR [IRSftyStkPct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSftyStkPolicy]  DEFAULT (' ') FOR [IRSftyStkPolicy]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRSourceCode]  DEFAULT (' ') FOR [IRSourceCode]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRTargetOrdMethod]  DEFAULT (' ') FOR [IRTargetOrdMethod]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRTargetOrdReq]  DEFAULT ((0)) FOR [IRTargetOrdReq]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_IRTransferSiteID]  DEFAULT (' ') FOR [IRTransferSiteID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ItemCommClassID]  DEFAULT (' ') FOR [ItemCommClassID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Kit]  DEFAULT ((0)) FOR [Kit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastBookQty]  DEFAULT ((0)) FOR [LastBookQty]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastCost]  DEFAULT ((0)) FOR [LastCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastCountDate]  DEFAULT ('01/01/1900') FOR [LastCountDate]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastSiteID]  DEFAULT (' ') FOR [LastSiteID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastStdCost]  DEFAULT ((0)) FOR [LastStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastVarAmt]  DEFAULT ((0)) FOR [LastVarAmt]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastVarPct]  DEFAULT ((0)) FOR [LastVarPct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LastVarQty]  DEFAULT ((0)) FOR [LastVarQty]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LCVarianceAcct]  DEFAULT (' ') FOR [LCVarianceAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LCVarianceSub]  DEFAULT (' ') FOR [LCVarianceSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LeadTime]  DEFAULT ((0)) FOR [LeadTime]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LinkSpecId]  DEFAULT ((0)) FOR [LinkSpecId]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerFxdLen]  DEFAULT ((0)) FOR [LotSerFxdLen]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerFxdTyp]  DEFAULT (' ') FOR [LotSerFxdTyp]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerFxdVal]  DEFAULT (' ') FOR [LotSerFxdVal]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerIssMthd]  DEFAULT (' ') FOR [LotSerIssMthd]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerNumLen]  DEFAULT ((0)) FOR [LotSerNumLen]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerNumVal]  DEFAULT (' ') FOR [LotSerNumVal]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LotSerTrack]  DEFAULT (' ') FOR [LotSerTrack]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MaterialType]  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MaxOnHand]  DEFAULT ((0)) FOR [MaxOnHand]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MfgClassID]  DEFAULT (' ') FOR [MfgClassID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MfgLeadTime]  DEFAULT ((0)) FOR [MfgLeadTime]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MinGrossProfit]  DEFAULT ((0)) FOR [MinGrossProfit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MoveClass]  DEFAULT (' ') FOR [MoveClass]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_MSDS]  DEFAULT (' ') FOR [MSDS]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Pack]  DEFAULT (' ') FOR [Pack]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PDirStdCost]  DEFAULT ((0)) FOR [PDirStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PerNbr]  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PFOvhStdCost]  DEFAULT ((0)) FOR [PFOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PPVAcct]  DEFAULT (' ') FOR [PPVAcct]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PPVSub]  DEFAULT (' ') FOR [PPVSub]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PriceClassID]  DEFAULT (' ') FOR [PriceClassID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ProdMgrID]  DEFAULT (' ') FOR [ProdMgrID]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ProductionUnit]  DEFAULT (' ') FOR [ProductionUnit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PStdCost]  DEFAULT ((0)) FOR [PStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PStdCostDate]  DEFAULT ('01/01/1900') FOR [PStdCostDate]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_PVOvhStdCost]  DEFAULT ((0)) FOR [PVOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ReordPt]  DEFAULT ((0)) FOR [ReordPt]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ReOrdPtCalc]  DEFAULT ((0)) FOR [ReOrdPtCalc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ReordQty]  DEFAULT ((0)) FOR [ReordQty]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ReOrdQtyCalc]  DEFAULT ((0)) FOR [ReOrdQtyCalc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ReplMthd]  DEFAULT (' ') FOR [ReplMthd]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_RollupCost]  DEFAULT ((0)) FOR [RollupCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_RollupPrice]  DEFAULT ((0)) FOR [RollupPrice]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_RvsdPrc]  DEFAULT ((0)) FOR [RvsdPrc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_S4Future13]  DEFAULT (' ') FOR [S4Future13]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_SafetyStk]  DEFAULT ((0)) FOR [SafetyStk]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_SafetyStkCalc]  DEFAULT ((0)) FOR [SafetyStkCalc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_SerAssign]  DEFAULT (' ') FOR [SerAssign]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Service]  DEFAULT ((0)) FOR [Service]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ShelfLife]  DEFAULT ((0)) FOR [ShelfLife]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Size]  DEFAULT (' ') FOR [Size]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Source]  DEFAULT (' ') FOR [Source]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StdCost]  DEFAULT ((0)) FOR [StdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StdCostDate]  DEFAULT ('01/01/1900') FOR [StdCostDate]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkBasePrc]  DEFAULT ((0)) FOR [StkBasePrc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkItem]  DEFAULT ((0)) FOR [StkItem]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkRvsdPrc]  DEFAULT ((0)) FOR [StkRvsdPrc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkTaxBasisPrc]  DEFAULT ((0)) FOR [StkTaxBasisPrc]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkUnit]  DEFAULT (' ') FOR [StkUnit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkVol]  DEFAULT ((0)) FOR [StkVol]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkWt]  DEFAULT ((0)) FOR [StkWt]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_StkWtUnit]  DEFAULT (' ') FOR [StkWtUnit]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Style]  DEFAULT (' ') FOR [Style]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Supplr1]  DEFAULT (' ') FOR [Supplr1]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Supplr2]  DEFAULT (' ') FOR [Supplr2]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_SupplrItem1]  DEFAULT (' ') FOR [SupplrItem1]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_SupplrItem2]  DEFAULT (' ') FOR [SupplrItem2]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_TaxCat]  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_TranStatusCode]  DEFAULT (' ') FOR [TranStatusCode]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_Turns]  DEFAULT ((0)) FOR [Turns]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_UPCCode]  DEFAULT (' ') FOR [UPCCode]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_UsageRate]  DEFAULT ((0)) FOR [UsageRate]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_ValMthd]  DEFAULT (' ') FOR [ValMthd]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_VOvhStdCost]  DEFAULT ((0)) FOR [VOvhStdCost]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_WarrantyDays]  DEFAULT ((0)) FOR [WarrantyDays]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_YTDUsage]  DEFAULT ((0)) FOR [YTDUsage]
GO
