USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[SOSetup]    Script Date: 12/21/2015 13:56:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOSetup](
	[AccrRevAcct] [char](10) NOT NULL,
	[AccrRevSub] [char](24) NOT NULL,
	[AddAlternateID] [smallint] NOT NULL,
	[AddDaysEarly] [smallint] NOT NULL,
	[AddDaysLate] [smallint] NOT NULL,
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[AllowDiscPrice] [smallint] NOT NULL,
	[AutoCreateShippers] [smallint] NOT NULL,
	[AutoInsertContacts] [smallint] NOT NULL,
	[AutoRef] [smallint] NOT NULL,
	[AutoReleaseBatches] [smallint] NOT NULL,
	[AutoSalesJournal] [char](1) NOT NULL,
	[AutoSave] [smallint] NOT NULL,
	[BillThruProject] [smallint] NOT NULL,
	[BookingLimit] [smallint] NOT NULL,
	[CashSaleCustID] [char](15) NOT NULL,
	[ChainDiscEnabled] [smallint] NOT NULL,
	[City] [char](30) NOT NULL,
	[ConsolInv] [smallint] NOT NULL,
	[CopyNotes] [smallint] NOT NULL,
	[CopyToInvc00] [char](1) NOT NULL,
	[CopyToInvc01] [char](1) NOT NULL,
	[CopyToInvc02] [char](1) NOT NULL,
	[CopyToInvc03] [char](1) NOT NULL,
	[CopyToInvc04] [char](1) NOT NULL,
	[CopyToInvc05] [char](1) NOT NULL,
	[CopyToInvc06] [char](1) NOT NULL,
	[CopyToInvc07] [char](1) NOT NULL,
	[CopyToShipper00] [char](1) NOT NULL,
	[CopyToShipper01] [char](1) NOT NULL,
	[CopyToShipper02] [char](1) NOT NULL,
	[CopyToShipper03] [char](1) NOT NULL,
	[CopyToShipper04] [char](1) NOT NULL,
	[CopyToShipper05] [char](1) NOT NULL,
	[CopyToShipper06] [char](1) NOT NULL,
	[CopyToShipper07] [char](1) NOT NULL,
	[CopyToShipper08] [char](1) NOT NULL,
	[CopyToShipper09] [char](1) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyName] [char](30) NOT NULL,
	[CreditCheck] [smallint] NOT NULL,
	[CreditGraceDays] [smallint] NOT NULL,
	[CreditGracePct] [float] NOT NULL,
	[CreditNoOrdEntry] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CutoffTime] [smalldatetime] NOT NULL,
	[DecPlNonStdQty] [smallint] NOT NULL,
	[DecPlPrice] [smallint] NOT NULL,
	[DelayManifestUpdate] [smallint] NOT NULL,
	[DelayShipperCreation] [smallint] NOT NULL,
	[DelayShipperUpdate] [smallint] NOT NULL,
	[DelayUpdOrd] [char](1) NOT NULL,
	[DfltAccrueRev] [smallint] NOT NULL,
	[DfltAltIDType] [char](1) NOT NULL,
	[DfltBillThruProject] [smallint] NOT NULL,
	[DfltConsolInv] [smallint] NOT NULL,
	[DfltDiscountID] [char](1) NOT NULL,
	[DfltOrderType] [char](10) NOT NULL,
	[DfltShipperType] [char](10) NOT NULL,
	[DfltSiteIDMethod] [char](1) NOT NULL,
	[DfltSlsperMethod] [char](1) NOT NULL,
	[DiscBySite] [smallint] NOT NULL,
	[DiscPrcDate] [char](1) NOT NULL,
	[DiscPrcSeq00] [char](2) NOT NULL,
	[DiscPrcSeq01] [char](2) NOT NULL,
	[DiscPrcSeq02] [char](2) NOT NULL,
	[DiscPrcSeq03] [char](2) NOT NULL,
	[DiscPrcSeq04] [char](2) NOT NULL,
	[DiscPrcSeq05] [char](2) NOT NULL,
	[DiscPrcSeq06] [char](2) NOT NULL,
	[DiscPrcSeq07] [char](2) NOT NULL,
	[DiscPrcSeq08] [char](2) NOT NULL,
	[DispAvailSO] [smallint] NOT NULL,
	[EarlyWarningCutoff] [smallint] NOT NULL,
	[ErrorAcct] [char](10) NOT NULL,
	[ErrorSub] [char](24) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[ForceValidSerialNo] [smallint] NOT NULL,
	[INAvail] [smallint] NOT NULL,
	[Init] [smallint] NOT NULL,
	[InvTaxCat] [smallint] NOT NULL,
	[InvtScrapAcct] [char](10) NOT NULL,
	[InvtScrapSub] [char](24) NOT NULL,
	[KAAvailAtETA] [smallint] NOT NULL,
	[LastRebateID] [char](10) NOT NULL,
	[LastShipRegisterID] [char](10) NOT NULL,
	[LookupSpecChar] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MinGPHandling] [char](1) NOT NULL,
	[NegQtyMsg] [char](1) NOT NULL,
	[NoQueueOnUnreserve] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerRetBook] [smallint] NOT NULL,
	[PerRetTran] [smallint] NOT NULL,
	[Phone] [char](30) NOT NULL,
	[PickTime] [smallint] NOT NULL,
	[PlanScheds] [smallint] NOT NULL,
	[POAvailAtETA] [smallint] NOT NULL,
	[PostBookings] [smallint] NOT NULL,
	[PrenumberedForms] [smallint] NOT NULL,
	[ProcManSleepSecs] [smallint] NOT NULL,
	[PrtCpny] [smallint] NOT NULL,
	[PrtSite] [smallint] NOT NULL,
	[PrtTax] [smallint] NOT NULL,
	[RMARequired] [smallint] NOT NULL,
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
	[SetupID] [char](2) NOT NULL,
	[ShipConfirmNegQty] [smallint] NOT NULL,
	[State] [char](3) NOT NULL,
	[TaxDet] [smallint] NOT NULL,
	[TermsOverride] [char](1) NOT NULL,
	[TotalOrdDisc] [smallint] NOT NULL,
	[TransferAvailAtETA] [smallint] NOT NULL,
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
	[WCShipViaID] [char](15) NOT NULL,
	[WOAvailAtETA] [smallint] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AccrRevAcct]  DEFAULT (' ') FOR [AccrRevAcct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AccrRevSub]  DEFAULT (' ') FOR [AccrRevSub]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AddAlternateID]  DEFAULT ((0)) FOR [AddAlternateID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AddDaysEarly]  DEFAULT ((0)) FOR [AddDaysEarly]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AddDaysLate]  DEFAULT ((0)) FOR [AddDaysLate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Addr1]  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Addr2]  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AllowDiscPrice]  DEFAULT ((0)) FOR [AllowDiscPrice]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AutoCreateShippers]  DEFAULT ((0)) FOR [AutoCreateShippers]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AutoInsertContacts]  DEFAULT ((0)) FOR [AutoInsertContacts]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AutoRef]  DEFAULT ((0)) FOR [AutoRef]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AutoReleaseBatches]  DEFAULT ((0)) FOR [AutoReleaseBatches]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AutoSalesJournal]  DEFAULT (' ') FOR [AutoSalesJournal]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_AutoSave]  DEFAULT ((0)) FOR [AutoSave]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_BillThruProject]  DEFAULT ((0)) FOR [BillThruProject]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_BookingLimit]  DEFAULT ((0)) FOR [BookingLimit]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CashSaleCustID]  DEFAULT (' ') FOR [CashSaleCustID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ChainDiscEnabled]  DEFAULT ((0)) FOR [ChainDiscEnabled]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_City]  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ConsolInv]  DEFAULT ((0)) FOR [ConsolInv]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyNotes]  DEFAULT ((0)) FOR [CopyNotes]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc00]  DEFAULT (' ') FOR [CopyToInvc00]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc01]  DEFAULT (' ') FOR [CopyToInvc01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc02]  DEFAULT (' ') FOR [CopyToInvc02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc03]  DEFAULT (' ') FOR [CopyToInvc03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc04]  DEFAULT (' ') FOR [CopyToInvc04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc05]  DEFAULT (' ') FOR [CopyToInvc05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc06]  DEFAULT (' ') FOR [CopyToInvc06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToInvc07]  DEFAULT (' ') FOR [CopyToInvc07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper00]  DEFAULT (' ') FOR [CopyToShipper00]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper01]  DEFAULT (' ') FOR [CopyToShipper01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper02]  DEFAULT (' ') FOR [CopyToShipper02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper03]  DEFAULT (' ') FOR [CopyToShipper03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper04]  DEFAULT (' ') FOR [CopyToShipper04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper05]  DEFAULT (' ') FOR [CopyToShipper05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper06]  DEFAULT (' ') FOR [CopyToShipper06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper07]  DEFAULT (' ') FOR [CopyToShipper07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper08]  DEFAULT (' ') FOR [CopyToShipper08]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CopyToShipper09]  DEFAULT (' ') FOR [CopyToShipper09]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Country]  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CpnyName]  DEFAULT (' ') FOR [CpnyName]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CreditCheck]  DEFAULT ((0)) FOR [CreditCheck]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CreditGraceDays]  DEFAULT ((0)) FOR [CreditGraceDays]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CreditGracePct]  DEFAULT ((0)) FOR [CreditGracePct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CreditNoOrdEntry]  DEFAULT ((0)) FOR [CreditNoOrdEntry]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_CutoffTime]  DEFAULT ('01/01/1900') FOR [CutoffTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DecPlNonStdQty]  DEFAULT ((0)) FOR [DecPlNonStdQty]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DecPlPrice]  DEFAULT ((0)) FOR [DecPlPrice]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DelayManifestUpdate]  DEFAULT ((0)) FOR [DelayManifestUpdate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DelayShipperCreation]  DEFAULT ((0)) FOR [DelayShipperCreation]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DelayShipperUpdate]  DEFAULT ((0)) FOR [DelayShipperUpdate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DelayUpdOrd]  DEFAULT (' ') FOR [DelayUpdOrd]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltAccrueRev]  DEFAULT ((0)) FOR [DfltAccrueRev]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltAltIDType]  DEFAULT (' ') FOR [DfltAltIDType]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltBillThruProject]  DEFAULT ((0)) FOR [DfltBillThruProject]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltConsolInv]  DEFAULT ((0)) FOR [DfltConsolInv]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltDiscountID]  DEFAULT (' ') FOR [DfltDiscountID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltOrderType]  DEFAULT (' ') FOR [DfltOrderType]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltShipperType]  DEFAULT (' ') FOR [DfltShipperType]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltSiteIDMethod]  DEFAULT (' ') FOR [DfltSiteIDMethod]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DfltSlsperMethod]  DEFAULT (' ') FOR [DfltSlsperMethod]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscBySite]  DEFAULT ((0)) FOR [DiscBySite]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcDate]  DEFAULT (' ') FOR [DiscPrcDate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq00]  DEFAULT (' ') FOR [DiscPrcSeq00]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq01]  DEFAULT (' ') FOR [DiscPrcSeq01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq02]  DEFAULT (' ') FOR [DiscPrcSeq02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq03]  DEFAULT (' ') FOR [DiscPrcSeq03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq04]  DEFAULT (' ') FOR [DiscPrcSeq04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq05]  DEFAULT (' ') FOR [DiscPrcSeq05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq06]  DEFAULT (' ') FOR [DiscPrcSeq06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq07]  DEFAULT (' ') FOR [DiscPrcSeq07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DiscPrcSeq08]  DEFAULT (' ') FOR [DiscPrcSeq08]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_DispAvailSO]  DEFAULT ((0)) FOR [DispAvailSO]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_EarlyWarningCutoff]  DEFAULT ((0)) FOR [EarlyWarningCutoff]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ErrorAcct]  DEFAULT (' ') FOR [ErrorAcct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ErrorSub]  DEFAULT (' ') FOR [ErrorSub]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Fax]  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ForceValidSerialNo]  DEFAULT ((0)) FOR [ForceValidSerialNo]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_INAvail]  DEFAULT ((0)) FOR [INAvail]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Init]  DEFAULT ((0)) FOR [Init]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_InvTaxCat]  DEFAULT ((0)) FOR [InvTaxCat]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_InvtScrapAcct]  DEFAULT (' ') FOR [InvtScrapAcct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_InvtScrapSub]  DEFAULT (' ') FOR [InvtScrapSub]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_KAAvailAtETA]  DEFAULT ((0)) FOR [KAAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_LastRebateID]  DEFAULT (' ') FOR [LastRebateID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_LastShipRegisterID]  DEFAULT (' ') FOR [LastShipRegisterID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_LookupSpecChar]  DEFAULT (' ') FOR [LookupSpecChar]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_MinGPHandling]  DEFAULT (' ') FOR [MinGPHandling]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_NegQtyMsg]  DEFAULT (' ') FOR [NegQtyMsg]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_NoQueueOnUnreserve]  DEFAULT ((0)) FOR [NoQueueOnUnreserve]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PerRetBook]  DEFAULT ((0)) FOR [PerRetBook]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PerRetTran]  DEFAULT ((0)) FOR [PerRetTran]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Phone]  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PickTime]  DEFAULT ((0)) FOR [PickTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PlanScheds]  DEFAULT ((0)) FOR [PlanScheds]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_POAvailAtETA]  DEFAULT ((0)) FOR [POAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PostBookings]  DEFAULT ((0)) FOR [PostBookings]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PrenumberedForms]  DEFAULT ((0)) FOR [PrenumberedForms]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ProcManSleepSecs]  DEFAULT ((0)) FOR [ProcManSleepSecs]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PrtCpny]  DEFAULT ((0)) FOR [PrtCpny]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PrtSite]  DEFAULT ((0)) FOR [PrtSite]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_PrtTax]  DEFAULT ((0)) FOR [PrtTax]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_RMARequired]  DEFAULT ((0)) FOR [RMARequired]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_SetupID]  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_ShipConfirmNegQty]  DEFAULT ((0)) FOR [ShipConfirmNegQty]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_State]  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_TaxDet]  DEFAULT ((0)) FOR [TaxDet]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_TermsOverride]  DEFAULT (' ') FOR [TermsOverride]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_TotalOrdDisc]  DEFAULT ((0)) FOR [TotalOrdDisc]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_TransferAvailAtETA]  DEFAULT ((0)) FOR [TransferAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_WCShipViaID]  DEFAULT (' ') FOR [WCShipViaID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_WOAvailAtETA]  DEFAULT ((0)) FOR [WOAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  CONSTRAINT [DF_SOSetup_Zip]  DEFAULT (' ') FOR [Zip]
GO
