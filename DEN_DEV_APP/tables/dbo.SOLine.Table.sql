USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[SOLine]    Script Date: 12/21/2015 14:05:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOLine](
	[AlternateID] [char](30) NOT NULL,
	[AltIDType] [char](1) NOT NULL,
	[AutoPO] [smallint] NOT NULL,
	[AutoPOVendID] [char](15) NOT NULL,
	[BlktOrdLineRef] [char](5) NOT NULL,
	[BlktOrdQty] [float] NOT NULL,
	[BMICost] [float] NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIEffDate] [smalldatetime] NOT NULL,
	[BMIExtPriceInvc] [float] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[BMIRtTp] [char](6) NOT NULL,
	[BMISlsPrice] [float] NOT NULL,
	[BoundToWO] [smallint] NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[ChainDisc] [char](15) NOT NULL,
	[CmmnPct] [float] NOT NULL,
	[CnvFact] [float] NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](24) NOT NULL,
	[CommCost] [float] NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCommCost] [float] NOT NULL,
	[CuryCost] [float] NOT NULL,
	[CuryListPrice] [float] NOT NULL,
	[CurySlsPrice] [float] NOT NULL,
	[CurySlsPriceOrig] [float] NOT NULL,
	[CuryTotCommCost] [float] NOT NULL,
	[CuryTotCost] [float] NOT NULL,
	[CuryTotOrd] [float] NOT NULL,
	[Descr] [char](60) NOT NULL,
	[DescrLang] [char](30) NOT NULL,
	[DiscAcct] [char](10) NOT NULL,
	[DiscPct] [float] NOT NULL,
	[DiscPrcType] [char](1) NOT NULL,
	[DiscSub] [char](24) NOT NULL,
	[Disp] [char](3) NOT NULL,
	[DropShip] [smallint] NOT NULL,
	[InclForecastUsageClc] [smallint] NOT NULL,
	[InspID] [char](2) NOT NULL,
	[InspNoteID] [int] NOT NULL,
	[InvAcct] [char](10) NOT NULL,
	[InvSub] [char](24) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[IRDemand] [smallint] NOT NULL,
	[IRInvtID] [char](30) NOT NULL,
	[IRProcessed] [smallint] NOT NULL,
	[IRSiteID] [char](10) NOT NULL,
	[ItemGLClassID] [char](4) NOT NULL,
	[KitComponent] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[ListPrice] [float] NOT NULL,
	[LotSerialReq] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[ManualCost] [smallint] NOT NULL,
	[ManualPrice] [smallint] NOT NULL,
	[NoteId] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[OrigINBatNbr] [char](10) NOT NULL,
	[OrigInvcNbr] [char](15) NOT NULL,
	[OrigInvtID] [char](30) NOT NULL,
	[OrigShipperCnvFact] [float] NOT NULL,
	[OrigShipperID] [char](15) NOT NULL,
	[OrigShipperLineQty] [float] NOT NULL,
	[OrigShipperLineRef] [char](5) NOT NULL,
	[OrigShipperUnitDesc] [char](6) NOT NULL,
	[OrigShipperMultDiv] [char](1) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[PromDate] [smalldatetime] NOT NULL,
	[QtyBO] [float] NOT NULL,
	[QtyCloseShip] [float] NOT NULL,
	[QtyFuture] [float] NOT NULL,
	[QtyOpenShip] [float] NOT NULL,
	[QtyOrd] [float] NOT NULL,
	[QtyShip] [float] NOT NULL,
	[QtyToInvc] [float] NOT NULL,
	[ReasonCd] [char](6) NOT NULL,
	[RebateID] [char](10) NOT NULL,
	[ReqDate] [smalldatetime] NOT NULL,
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
	[SalesPriceID] [char](15) NOT NULL,
	[Sample] [smallint] NOT NULL,
	[SchedCntr] [smallint] NOT NULL,
	[Service] [smallint] NOT NULL,
	[ShipWght] [float] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[SlsPrice] [float] NOT NULL,
	[SlsPriceID] [char](15) NOT NULL,
	[SlsPriceOrig] [float] NOT NULL,
	[SlsSub] [char](24) NOT NULL,
	[SplitLots] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[Taxable] [smallint] NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TotCommCost] [float] NOT NULL,
	[TotCost] [float] NOT NULL,
	[TotOrd] [float] NOT NULL,
	[TotShipWght] [float] NOT NULL,
	[UnitDesc] [char](6) NOT NULL,
	[UnitMultDiv] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [SOLine0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[OrdNbr] ASC,
	[LineRef] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_AlternateID]  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_AltIDType]  DEFAULT (' ') FOR [AltIDType]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_AutoPO]  DEFAULT ((0)) FOR [AutoPO]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_AutoPOVendID]  DEFAULT (' ') FOR [AutoPOVendID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BlktOrdLineRef]  DEFAULT (' ') FOR [BlktOrdLineRef]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BlktOrdQty]  DEFAULT ((0)) FOR [BlktOrdQty]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMICost]  DEFAULT ((0)) FOR [BMICost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMICuryID]  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMIEffDate]  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMIExtPriceInvc]  DEFAULT ((0)) FOR [BMIExtPriceInvc]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMIMultDiv]  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMIRate]  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMIRtTp]  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BMISlsPrice]  DEFAULT ((0)) FOR [BMISlsPrice]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_BoundToWO]  DEFAULT ((0)) FOR [BoundToWO]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ChainDisc]  DEFAULT (' ') FOR [ChainDisc]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CmmnPct]  DEFAULT ((0)) FOR [CmmnPct]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_COGSAcct]  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_COGSSub]  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CommCost]  DEFAULT ((0)) FOR [CommCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CuryCommCost]  DEFAULT ((0)) FOR [CuryCommCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CuryCost]  DEFAULT ((0)) FOR [CuryCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CuryListPrice]  DEFAULT ((0)) FOR [CuryListPrice]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CurySlsPrice]  DEFAULT ((0)) FOR [CurySlsPrice]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CurySlsPriceOrig]  DEFAULT ((0)) FOR [CurySlsPriceOrig]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CuryTotCommCost]  DEFAULT ((0)) FOR [CuryTotCommCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CuryTotCost]  DEFAULT ((0)) FOR [CuryTotCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_CuryTotOrd]  DEFAULT ((0)) FOR [CuryTotOrd]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_DescrLang]  DEFAULT (' ') FOR [DescrLang]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_DiscAcct]  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_DiscPct]  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_DiscPrcType]  DEFAULT (' ') FOR [DiscPrcType]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_DiscSub]  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Disp]  DEFAULT (' ') FOR [Disp]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_DropShip]  DEFAULT ((0)) FOR [DropShip]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_InclForecastUsageClc]  DEFAULT ((0)) FOR [InclForecastUsageClc]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_InspID]  DEFAULT (' ') FOR [InspID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_InspNoteID]  DEFAULT ((0)) FOR [InspNoteID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_InvAcct]  DEFAULT (' ') FOR [InvAcct]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_InvSub]  DEFAULT (' ') FOR [InvSub]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_IRDemand]  DEFAULT ((0)) FOR [IRDemand]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_IRInvtID]  DEFAULT (' ') FOR [IRInvtID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_IRProcessed]  DEFAULT ((0)) FOR [IRProcessed]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_IRSiteID]  DEFAULT (' ') FOR [IRSiteID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ItemGLClassID]  DEFAULT (' ') FOR [ItemGLClassID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_KitComponent]  DEFAULT ((0)) FOR [KitComponent]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ListPrice]  DEFAULT ((0)) FOR [ListPrice]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_LotSerialReq]  DEFAULT ((0)) FOR [LotSerialReq]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ManualCost]  DEFAULT ((0)) FOR [ManualCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ManualPrice]  DEFAULT ((0)) FOR [ManualPrice]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_NoteId]  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigINBatNbr]  DEFAULT (' ') FOR [OrigINBatNbr]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigInvcNbr]  DEFAULT (' ') FOR [OrigInvcNbr]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigInvtID]  DEFAULT (' ') FOR [OrigInvtID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigShipperCnvFact]  DEFAULT ((0)) FOR [OrigShipperCnvFact]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigShipperID]  DEFAULT (' ') FOR [OrigShipperID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigShipperLineQty]  DEFAULT ((0)) FOR [OrigShipperLineQty]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigShipperLineRef]  DEFAULT (' ') FOR [OrigShipperLineRef]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigShipperUnitDesc]  DEFAULT (' ') FOR [OrigShipperUnitDesc]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_OrigShipperMultDiv]  DEFAULT (' ') FOR [OrigShipperMultDiv]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_PromDate]  DEFAULT ('01/01/1900') FOR [PromDate]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyBO]  DEFAULT ((0)) FOR [QtyBO]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyCloseShip]  DEFAULT ((0)) FOR [QtyCloseShip]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyFuture]  DEFAULT ((0)) FOR [QtyFuture]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyOpenShip]  DEFAULT ((0)) FOR [QtyOpenShip]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyOrd]  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyShip]  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_QtyToInvc]  DEFAULT ((0)) FOR [QtyToInvc]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ReasonCd]  DEFAULT (' ') FOR [ReasonCd]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_RebateID]  DEFAULT (' ') FOR [RebateID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ReqDate]  DEFAULT ('01/01/1900') FOR [ReqDate]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SalesPriceID]  DEFAULT (' ') FOR [SalesPriceID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Sample]  DEFAULT ((0)) FOR [Sample]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SchedCntr]  DEFAULT ((0)) FOR [SchedCntr]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Service]  DEFAULT ((0)) FOR [Service]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_ShipWght]  DEFAULT ((0)) FOR [ShipWght]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SlsAcct]  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SlsperID]  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SlsPrice]  DEFAULT ((0)) FOR [SlsPrice]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SlsPriceID]  DEFAULT (' ') FOR [SlsPriceID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SlsPriceOrig]  DEFAULT ((0)) FOR [SlsPriceOrig]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SlsSub]  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_SplitLots]  DEFAULT ((0)) FOR [SplitLots]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_Taxable]  DEFAULT ((0)) FOR [Taxable]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_TaxCat]  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_TotCommCost]  DEFAULT ((0)) FOR [TotCommCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_TotCost]  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_TotOrd]  DEFAULT ((0)) FOR [TotOrd]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_TotShipWght]  DEFAULT ((0)) FOR [TotShipWght]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_UnitDesc]  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOLine] ADD  CONSTRAINT [DF_SOLine_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
