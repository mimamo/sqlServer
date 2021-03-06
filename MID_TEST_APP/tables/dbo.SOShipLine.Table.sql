USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[SOShipLine]    Script Date: 12/21/2015 14:26:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOShipLine](
	[AlternateID] [char](30) NOT NULL,
	[AltIDType] [char](1) NOT NULL,
	[AvgCost] [float] NOT NULL,
	[BMICost] [float] NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIEffDate] [smalldatetime] NOT NULL,
	[BMIExtPriceInvc] [float] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[BMIRtTp] [char](6) NOT NULL,
	[BMISlsPrice] [float] NOT NULL,
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
	[CuryTaxAmt00] [float] NOT NULL,
	[CuryTaxAmt01] [float] NOT NULL,
	[CuryTaxAmt02] [float] NOT NULL,
	[CuryTaxAmt03] [float] NOT NULL,
	[CuryTotCommCost] [float] NOT NULL,
	[CuryTotCost] [float] NOT NULL,
	[CuryTotInvc] [float] NOT NULL,
	[CuryTotMerch] [float] NOT NULL,
	[CuryTxblAmt00] [float] NOT NULL,
	[CuryTxblAmt01] [float] NOT NULL,
	[CuryTxblAmt02] [float] NOT NULL,
	[CuryTxblAmt03] [float] NOT NULL,
	[Descr] [char](60) NOT NULL,
	[DescrLang] [char](30) NOT NULL,
	[DiscAcct] [char](10) NOT NULL,
	[DiscPct] [float] NOT NULL,
	[DiscSub] [char](24) NOT NULL,
	[Disp] [char](3) NOT NULL,
	[InspID] [char](2) NOT NULL,
	[InspNoteID] [int] NOT NULL,
	[InvAcct] [char](10) NOT NULL,
	[InvSub] [char](24) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[IRDemand] [smallint] NOT NULL,
	[IRInvtID] [char](30) NOT NULL,
	[IRSiteID] [char](10) NOT NULL,
	[ItemGLClassID] [char](4) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[ListPrice] [float] NOT NULL,
	[LotSerCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[ManualCost] [smallint] NOT NULL,
	[ManualPrice] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdLineRef] [char](5) NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[OrigBO] [float] NOT NULL,
	[OrigINBatNbr] [char](10) NOT NULL,
	[OrigInvcNbr] [char](15) NOT NULL,
	[OrigInvtID] [char](30) NOT NULL,
	[OrigShipperID] [char](15) NOT NULL,
	[OrigShipperLineRef] [char](5) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[QtyBO] [float] NOT NULL,
	[QtyFuture] [float] NOT NULL,
	[QtyOrd] [float] NOT NULL,
	[QtyPick] [float] NOT NULL,
	[QtyPrevShip] [float] NOT NULL,
	[QtyShip] [float] NOT NULL,
	[RebateID] [char](10) NOT NULL,
	[RebatePer] [char](6) NOT NULL,
	[RebateRefNbr] [char](10) NOT NULL,
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
	[Sample] [smallint] NOT NULL,
	[Service] [smallint] NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[ShipWght] [float] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[SlsPrice] [float] NOT NULL,
	[SlsPriceID] [char](15) NOT NULL,
	[SlsSub] [char](24) NOT NULL,
	[SplitLots] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[Taxable] [smallint] NOT NULL,
	[TaxAmt00] [float] NOT NULL,
	[TaxAmt01] [float] NOT NULL,
	[TaxAmt02] [float] NOT NULL,
	[TaxAmt03] [float] NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TaxIDDflt] [char](10) NOT NULL,
	[TotCommCost] [float] NOT NULL,
	[TotCost] [float] NOT NULL,
	[TotInvc] [float] NOT NULL,
	[TotMerch] [float] NOT NULL,
	[TxblAmt00] [float] NOT NULL,
	[TxblAmt01] [float] NOT NULL,
	[TxblAmt02] [float] NOT NULL,
	[TxblAmt03] [float] NOT NULL,
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
 CONSTRAINT [SOShipLine0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[ShipperID] ASC,
	[LineRef] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [AltIDType]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [AvgCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [BMICost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [BMIExtPriceInvc]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [BMISlsPrice]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [ChainDisc]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CmmnPct]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CommCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryCommCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryListPrice]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CurySlsPrice]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTaxAmt00]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTaxAmt01]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTaxAmt02]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTaxAmt03]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTotCommCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTotCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTotInvc]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTotMerch]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTxblAmt00]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTxblAmt01]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTxblAmt02]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [CuryTxblAmt03]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [DescrLang]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [Disp]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [InspID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [InspNoteID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [InvAcct]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [InvSub]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [IRDemand]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [IRInvtID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [IRSiteID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [ItemGLClassID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [ListPrice]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [LotSerCntr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [ManualCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [ManualPrice]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrdLineRef]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [OrigBO]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrigINBatNbr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrigInvcNbr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrigInvtID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrigShipperID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [OrigShipperLineRef]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [QtyBO]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [QtyFuture]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [QtyPick]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [QtyPrevShip]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [RebateID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [RebatePer]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [RebateRefNbr]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [Sample]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [Service]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [ShipWght]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [SlsPrice]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [SlsPriceID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [SplitLots]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [Taxable]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TaxAmt00]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TaxAmt01]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TaxAmt02]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TaxAmt03]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [TaxIDDflt]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TotCommCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TotInvc]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TotMerch]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TxblAmt00]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TxblAmt01]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TxblAmt02]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [TxblAmt03]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOShipLine] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
