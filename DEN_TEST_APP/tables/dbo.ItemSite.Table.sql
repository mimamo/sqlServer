USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[ItemSite]    Script Date: 12/21/2015 14:10:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemSite](
	[ABCCode] [char](2) NOT NULL,
	[AllocQty] [float] NOT NULL,
	[AutoPODropShip] [smallint] NOT NULL,
	[AutoPOPolicy] [char](2) NOT NULL,
	[AvgCost] [float] NOT NULL,
	[BMIAvgCost] [float] NOT NULL,
	[BMIDirStdCst] [float] NOT NULL,
	[BMIFOvhStdCst] [float] NOT NULL,
	[BMILastCost] [float] NOT NULL,
	[BMIPDirStdCst] [float] NOT NULL,
	[BMIPFOvhStdCst] [float] NOT NULL,
	[BMIPStdCst] [float] NOT NULL,
	[BMIPVOvhStdCst] [float] NOT NULL,
	[BMIStdCost] [float] NOT NULL,
	[BMITotCost] [float] NOT NULL,
	[BMIVOvhStdCst] [float] NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](24) NOT NULL,
	[CountStatus] [char](1) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CycleID] [char](10) NOT NULL,
	[DfltPickBin] [char](10) NOT NULL,
	[DfltPOUnit] [char](6) NOT NULL,
	[DfltPutAwayBin] [char](10) NOT NULL,
	[DfltRepairBin] [char](10) NOT NULL,
	[DfltSOUnit] [char](6) NOT NULL,
	[DfltVendorBin] [char](10) NOT NULL,
	[DfltWhseLoc] [char](10) NOT NULL,
	[DirStdCst] [float] NOT NULL,
	[EOQ] [float] NOT NULL,
	[FOvhStdCst] [float] NOT NULL,
	[InvtAcct] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[InvtSub] [char](24) NOT NULL,
	[IRCalcDailyUsage] [float] NOT NULL,
	[IRCalcEOQ] [float] NOT NULL,
	[IRCalcLeadTime] [float] NOT NULL,
	[IRCalcLinePt] [float] NOT NULL,
	[IRCalcRCycDays] [int] NOT NULL,
	[IRCalcReOrdPt] [float] NOT NULL,
	[IRCalcReOrdQty] [float] NOT NULL,
	[IRCalcSafetyStk] [float] NOT NULL,
	[IRDailyUsage] [float] NOT NULL,
	[IRDaysSupply] [float] NOT NULL,
	[IRDemandID] [char](10) NOT NULL,
	[IRFutureDate] [smalldatetime] NOT NULL,
	[IRFuturePolicy] [char](1) NOT NULL,
	[IRLeadTimeID] [char](10) NOT NULL,
	[IRLinePt] [float] NOT NULL,
	[IRManualDailyUsage] [smallint] NOT NULL,
	[IRManualEOQ] [smallint] NOT NULL,
	[IRManualLeadTime] [smallint] NOT NULL,
	[IRManualLinePt] [smallint] NOT NULL,
	[IRManualRCycDays] [smallint] NOT NULL,
	[IRManualReOrdPt] [smallint] NOT NULL,
	[IRManualReOrdQty] [smallint] NOT NULL,
	[IRManualSafetyStk] [smallint] NOT NULL,
	[IRMaxDailyUsage] [float] NOT NULL,
	[IRMaxEOQ] [float] NOT NULL,
	[IRMaxLeadTime] [float] NOT NULL,
	[IRMaxLinePt] [float] NOT NULL,
	[IRMaxRCycDays] [float] NOT NULL,
	[IRMaxReOrdPt] [float] NOT NULL,
	[IRMaxReOrdQty] [float] NOT NULL,
	[IRMaxSafetyStk] [float] NOT NULL,
	[IRMinDailyUsage] [float] NOT NULL,
	[IRMinEOQ] [float] NOT NULL,
	[IRMinLeadTime] [float] NOT NULL,
	[IRMinLinePt] [float] NOT NULL,
	[IRMinOnHand] [float] NOT NULL,
	[IRMinRCycDays] [float] NOT NULL,
	[IRMinReOrdPt] [float] NOT NULL,
	[IRMinReOrdQty] [float] NOT NULL,
	[IRMinSafetyStk] [float] NOT NULL,
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
	[LastBookQty] [float] NOT NULL,
	[LastCost] [float] NOT NULL,
	[LastCountDate] [smalldatetime] NOT NULL,
	[LastPurchaseDate] [smalldatetime] NOT NULL,
	[LastPurchasePrice] [float] NOT NULL,
	[LastStdCost] [float] NOT NULL,
	[LastVarAmt] [float] NOT NULL,
	[LastVarPct] [float] NOT NULL,
	[LastVarQty] [float] NOT NULL,
	[LastVendor] [char](15) NOT NULL,
	[LeadTime] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaxOnHand] [float] NOT NULL,
	[MfgClassID] [char](10) NOT NULL,
	[MfgLeadTime] [float] NOT NULL,
	[MoveClass] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PDirStdCst] [float] NOT NULL,
	[PFOvhStdCst] [float] NOT NULL,
	[PrimVendID] [char](15) NOT NULL,
	[ProdMgrID] [char](10) NOT NULL,
	[PStdCostDate] [smalldatetime] NOT NULL,
	[PStdCst] [float] NOT NULL,
	[PVOvhStdCst] [float] NOT NULL,
	[QtyAlloc] [float] NOT NULL,
	[QtyAllocBM] [float] NOT NULL,
	[QtyAllocIN] [float] NOT NULL,
	[QtyAllocOther] [float] NOT NULL,
	[QtyAllocPORet] [float] NOT NULL,
	[QtyAllocSD] [float] NOT NULL,
	[QtyAllocSO] [float] NOT NULL,
	[QtyAvail] [float] NOT NULL,
	[QtyCustOrd] [float] NOT NULL,
	[QtyInTransit] [float] NOT NULL,
	[QtyNotAvail] [float] NOT NULL,
	[QtyOnBO] [float] NOT NULL,
	[QtyOnDP] [float] NOT NULL,
	[QtyOnHand] [float] NOT NULL,
	[QtyOnKitAssyOrders] [float] NOT NULL,
	[QtyOnPO] [float] NOT NULL,
	[QtyOnTransferOrders] [float] NOT NULL,
	[QtyShipNotInv] [float] NOT NULL,
	[QtyWOFirmDemand] [float] NOT NULL,
	[QtyWOFirmSupply] [float] NOT NULL,
	[QtyWORlsedDemand] [float] NOT NULL,
	[QtyWORlsedSupply] [float] NOT NULL,
	[ReordInterval] [smallint] NOT NULL,
	[ReordPt] [float] NOT NULL,
	[ReordPtCalc] [float] NOT NULL,
	[ReordQty] [float] NOT NULL,
	[ReordQtyCalc] [float] NOT NULL,
	[ReplMthd] [char](1) NOT NULL,
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
	[SafetyStk] [float] NOT NULL,
	[SafetyStkCalc] [float] NOT NULL,
	[SalesAcct] [char](10) NOT NULL,
	[SalesSub] [char](24) NOT NULL,
	[SecondVendID] [char](15) NOT NULL,
	[Selected] [smallint] NOT NULL,
	[ShipNotInvAcct] [char](10) NOT NULL,
	[ShipNotInvSub] [char](24) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[StdCost] [float] NOT NULL,
	[StdCostDate] [smalldatetime] NOT NULL,
	[StkItem] [smallint] NOT NULL,
	[TotCost] [float] NOT NULL,
	[Turns] [float] NOT NULL,
	[UsageRate] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VOvhStdCst] [float] NOT NULL,
	[YTDUsage] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [ItemSite0] PRIMARY KEY CLUSTERED 
(
	[InvtID] ASC,
	[SiteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ABCCode]  DEFAULT (' ') FOR [ABCCode]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_AllocQty]  DEFAULT ((0)) FOR [AllocQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_AutoPODropShip]  DEFAULT ((0)) FOR [AutoPODropShip]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_AutoPOPolicy]  DEFAULT (' ') FOR [AutoPOPolicy]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_AvgCost]  DEFAULT ((0)) FOR [AvgCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIAvgCost]  DEFAULT ((0)) FOR [BMIAvgCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIDirStdCst]  DEFAULT ((0)) FOR [BMIDirStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIFOvhStdCst]  DEFAULT ((0)) FOR [BMIFOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMILastCost]  DEFAULT ((0)) FOR [BMILastCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIPDirStdCst]  DEFAULT ((0)) FOR [BMIPDirStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIPFOvhStdCst]  DEFAULT ((0)) FOR [BMIPFOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIPStdCst]  DEFAULT ((0)) FOR [BMIPStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIPVOvhStdCst]  DEFAULT ((0)) FOR [BMIPVOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIStdCost]  DEFAULT ((0)) FOR [BMIStdCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMITotCost]  DEFAULT ((0)) FOR [BMITotCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_BMIVOvhStdCst]  DEFAULT ((0)) FOR [BMIVOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_COGSAcct]  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_COGSSub]  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_CountStatus]  DEFAULT ('A') FOR [CountStatus]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_CycleID]  DEFAULT (' ') FOR [CycleID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltPickBin]  DEFAULT (' ') FOR [DfltPickBin]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltPOUnit]  DEFAULT (' ') FOR [DfltPOUnit]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltPutAwayBin]  DEFAULT (' ') FOR [DfltPutAwayBin]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltRepairBin]  DEFAULT (' ') FOR [DfltRepairBin]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltSOUnit]  DEFAULT (' ') FOR [DfltSOUnit]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltVendorBin]  DEFAULT (' ') FOR [DfltVendorBin]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DfltWhseLoc]  DEFAULT (' ') FOR [DfltWhseLoc]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_DirStdCst]  DEFAULT ((0)) FOR [DirStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_EOQ]  DEFAULT ((0)) FOR [EOQ]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_FOvhStdCst]  DEFAULT ((0)) FOR [FOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_InvtAcct]  DEFAULT (' ') FOR [InvtAcct]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_InvtSub]  DEFAULT (' ') FOR [InvtSub]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcDailyUsage]  DEFAULT ((0)) FOR [IRCalcDailyUsage]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcEOQ]  DEFAULT ((0)) FOR [IRCalcEOQ]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcLeadTime]  DEFAULT ((0)) FOR [IRCalcLeadTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcLinePt]  DEFAULT ((0)) FOR [IRCalcLinePt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcRCycDays]  DEFAULT ((0)) FOR [IRCalcRCycDays]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcReOrdPt]  DEFAULT ((0)) FOR [IRCalcReOrdPt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcReOrdQty]  DEFAULT ((0)) FOR [IRCalcReOrdQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRCalcSafetyStk]  DEFAULT ((0)) FOR [IRCalcSafetyStk]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRDailyUsage]  DEFAULT ((0)) FOR [IRDailyUsage]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRDaysSupply]  DEFAULT ((0)) FOR [IRDaysSupply]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRDemandID]  DEFAULT (' ') FOR [IRDemandID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRFutureDate]  DEFAULT ('01/01/1900') FOR [IRFutureDate]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRFuturePolicy]  DEFAULT (' ') FOR [IRFuturePolicy]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRLeadTimeID]  DEFAULT (' ') FOR [IRLeadTimeID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRLinePt]  DEFAULT ((0)) FOR [IRLinePt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualDailyUsage]  DEFAULT ((0)) FOR [IRManualDailyUsage]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualEOQ]  DEFAULT ((0)) FOR [IRManualEOQ]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualLeadTime]  DEFAULT ((0)) FOR [IRManualLeadTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualLinePt]  DEFAULT ((0)) FOR [IRManualLinePt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualRCycDays]  DEFAULT ((0)) FOR [IRManualRCycDays]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualReOrdPt]  DEFAULT ((0)) FOR [IRManualReOrdPt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualReOrdQty]  DEFAULT ((0)) FOR [IRManualReOrdQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRManualSafetyStk]  DEFAULT ((0)) FOR [IRManualSafetyStk]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxDailyUsage]  DEFAULT ((0)) FOR [IRMaxDailyUsage]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxEOQ]  DEFAULT ((0)) FOR [IRMaxEOQ]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxLeadTime]  DEFAULT ((0)) FOR [IRMaxLeadTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxLinePt]  DEFAULT ((0)) FOR [IRMaxLinePt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxRCycDays]  DEFAULT ((0)) FOR [IRMaxRCycDays]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxReOrdPt]  DEFAULT ((0)) FOR [IRMaxReOrdPt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxReOrdQty]  DEFAULT ((0)) FOR [IRMaxReOrdQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMaxSafetyStk]  DEFAULT ((0)) FOR [IRMaxSafetyStk]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinDailyUsage]  DEFAULT ((0)) FOR [IRMinDailyUsage]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinEOQ]  DEFAULT ((0)) FOR [IRMinEOQ]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinLeadTime]  DEFAULT ((0)) FOR [IRMinLeadTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinLinePt]  DEFAULT ((0)) FOR [IRMinLinePt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinOnHand]  DEFAULT ((0)) FOR [IRMinOnHand]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinRCycDays]  DEFAULT ((0)) FOR [IRMinRCycDays]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinReOrdPt]  DEFAULT ((0)) FOR [IRMinReOrdPt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinReOrdQty]  DEFAULT ((0)) FOR [IRMinReOrdQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRMinSafetyStk]  DEFAULT ((0)) FOR [IRMinSafetyStk]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRModelInvtID]  DEFAULT (' ') FOR [IRModelInvtID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRRCycDays]  DEFAULT ((0)) FOR [IRRCycDays]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSeasonEndDay]  DEFAULT ((0)) FOR [IRSeasonEndDay]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSeasonEndMon]  DEFAULT ((0)) FOR [IRSeasonEndMon]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSeasonStrtDay]  DEFAULT ((0)) FOR [IRSeasonStrtDay]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSeasonStrtMon]  DEFAULT ((0)) FOR [IRSeasonStrtMon]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRServiceLevel]  DEFAULT ((0)) FOR [IRServiceLevel]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSftyStkDays]  DEFAULT ((0)) FOR [IRSftyStkDays]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSftyStkPct]  DEFAULT ((0)) FOR [IRSftyStkPct]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSftyStkPolicy]  DEFAULT (' ') FOR [IRSftyStkPolicy]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRSourceCode]  DEFAULT (' ') FOR [IRSourceCode]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRTargetOrdMethod]  DEFAULT (' ') FOR [IRTargetOrdMethod]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRTargetOrdReq]  DEFAULT ((0)) FOR [IRTargetOrdReq]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_IRTransferSiteID]  DEFAULT (' ') FOR [IRTransferSiteID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastBookQty]  DEFAULT ((0)) FOR [LastBookQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastCost]  DEFAULT ((0)) FOR [LastCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastCountDate]  DEFAULT ('01/01/1900') FOR [LastCountDate]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastPurchaseDate]  DEFAULT ('01/01/1900') FOR [LastPurchaseDate]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastPurchasePrice]  DEFAULT ((0)) FOR [LastPurchasePrice]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastStdCost]  DEFAULT ((0)) FOR [LastStdCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastVarAmt]  DEFAULT ((0)) FOR [LastVarAmt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastVarPct]  DEFAULT ((0)) FOR [LastVarPct]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastVarQty]  DEFAULT ((0)) FOR [LastVarQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LastVendor]  DEFAULT (' ') FOR [LastVendor]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LeadTime]  DEFAULT ((999)) FOR [LeadTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_MaxOnHand]  DEFAULT ((0)) FOR [MaxOnHand]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_MfgClassID]  DEFAULT (' ') FOR [MfgClassID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_MfgLeadTime]  DEFAULT ((0)) FOR [MfgLeadTime]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_MoveClass]  DEFAULT (' ') FOR [MoveClass]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_PDirStdCst]  DEFAULT ((0)) FOR [PDirStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_PFOvhStdCst]  DEFAULT ((0)) FOR [PFOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_PrimVendID]  DEFAULT (' ') FOR [PrimVendID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ProdMgrID]  DEFAULT (' ') FOR [ProdMgrID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_PStdCostDate]  DEFAULT ('01/01/1900') FOR [PStdCostDate]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_PStdCst]  DEFAULT ((0)) FOR [PStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_PVOvhStdCst]  DEFAULT ((0)) FOR [PVOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAlloc]  DEFAULT ((0)) FOR [QtyAlloc]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAllocBM]  DEFAULT ((0)) FOR [QtyAllocBM]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAllocIN]  DEFAULT ((0)) FOR [QtyAllocIN]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAllocOther]  DEFAULT ((0)) FOR [QtyAllocOther]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAllocPORet]  DEFAULT ((0)) FOR [QtyAllocPORet]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAllocSD]  DEFAULT ((0)) FOR [QtyAllocSD]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAllocSO]  DEFAULT ((0)) FOR [QtyAllocSO]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyAvail]  DEFAULT ((0)) FOR [QtyAvail]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyCustOrd]  DEFAULT ((0)) FOR [QtyCustOrd]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyInTransit]  DEFAULT ((0)) FOR [QtyInTransit]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyNotAvail]  DEFAULT ((0)) FOR [QtyNotAvail]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyOnBO]  DEFAULT ((0)) FOR [QtyOnBO]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyOnDP]  DEFAULT ((0)) FOR [QtyOnDP]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyOnHand]  DEFAULT ((0)) FOR [QtyOnHand]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyOnKitAssyOrders]  DEFAULT ((0)) FOR [QtyOnKitAssyOrders]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyOnPO]  DEFAULT ((0)) FOR [QtyOnPO]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyOnTransferOrders]  DEFAULT ((0)) FOR [QtyOnTransferOrders]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyShipNotInv]  DEFAULT ((0)) FOR [QtyShipNotInv]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyWOFirmDemand]  DEFAULT ((0)) FOR [QtyWOFirmDemand]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyWOFirmSupply]  DEFAULT ((0)) FOR [QtyWOFirmSupply]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyWORlsedDemand]  DEFAULT ((0)) FOR [QtyWORlsedDemand]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_QtyWORlsedSupply]  DEFAULT ((0)) FOR [QtyWORlsedSupply]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ReordInterval]  DEFAULT ((0)) FOR [ReordInterval]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ReordPt]  DEFAULT ((0)) FOR [ReordPt]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ReordPtCalc]  DEFAULT ((0)) FOR [ReordPtCalc]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ReordQty]  DEFAULT ((0)) FOR [ReordQty]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ReordQtyCalc]  DEFAULT ((0)) FOR [ReordQtyCalc]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ReplMthd]  DEFAULT (' ') FOR [ReplMthd]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_SafetyStk]  DEFAULT ((0)) FOR [SafetyStk]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_SafetyStkCalc]  DEFAULT ((0)) FOR [SafetyStkCalc]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_SalesAcct]  DEFAULT (' ') FOR [SalesAcct]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_SalesSub]  DEFAULT (' ') FOR [SalesSub]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_SecondVendID]  DEFAULT (' ') FOR [SecondVendID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ShipNotInvAcct]  DEFAULT (' ') FOR [ShipNotInvAcct]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_ShipNotInvSub]  DEFAULT (' ') FOR [ShipNotInvSub]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_StdCost]  DEFAULT ((0)) FOR [StdCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_StdCostDate]  DEFAULT ('01/01/1900') FOR [StdCostDate]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_StkItem]  DEFAULT ((0)) FOR [StkItem]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_TotCost]  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_Turns]  DEFAULT ((0)) FOR [Turns]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_UsageRate]  DEFAULT ((0)) FOR [UsageRate]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_VOvhStdCst]  DEFAULT ((0)) FOR [VOvhStdCst]
GO
ALTER TABLE [dbo].[ItemSite] ADD  CONSTRAINT [DF_ItemSite_YTDUsage]  DEFAULT ((0)) FOR [YTDUsage]
GO
