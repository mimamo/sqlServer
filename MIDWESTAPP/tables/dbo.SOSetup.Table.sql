USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[SOSetup]    Script Date: 12/21/2015 15:54:55 ******/
SET ANSI_NULLS ON
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
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [AccrRevAcct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [AccrRevSub]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AddAlternateID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AddDaysEarly]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AddDaysLate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AllowDiscPrice]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AutoCreateShippers]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AutoInsertContacts]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AutoRef]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AutoReleaseBatches]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [AutoSalesJournal]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [AutoSave]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [BillThruProject]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [BookingLimit]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CashSaleCustID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [ChainDiscEnabled]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [ConsolInv]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [CopyNotes]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc00]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToInvc07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper00]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper08]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CopyToShipper09]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [CpnyName]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [CreditCheck]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [CreditGraceDays]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [CreditGracePct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [CreditNoOrdEntry]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ('01/01/1900') FOR [CutoffTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DecPlNonStdQty]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DecPlPrice]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DelayManifestUpdate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DelayShipperCreation]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DelayShipperUpdate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DelayUpdOrd]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DfltAccrueRev]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DfltAltIDType]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DfltBillThruProject]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DfltConsolInv]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DfltDiscountID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DfltOrderType]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DfltShipperType]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DfltSiteIDMethod]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DfltSlsperMethod]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DiscBySite]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcDate]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq00]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [DiscPrcSeq08]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [DispAvailSO]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [EarlyWarningCutoff]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [ErrorAcct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [ErrorSub]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [ForceValidSerialNo]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [INAvail]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [Init]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [InvTaxCat]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [InvtScrapAcct]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [InvtScrapSub]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [KAAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [LastRebateID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [LastShipRegisterID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [LookupSpecChar]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [MinGPHandling]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [NegQtyMsg]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [NoQueueOnUnreserve]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PerRetBook]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PerRetTran]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PickTime]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PlanScheds]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [POAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PostBookings]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PrenumberedForms]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [ProcManSleepSecs]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PrtCpny]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PrtSite]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [PrtTax]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [RMARequired]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [ShipConfirmNegQty]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [TaxDet]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [TermsOverride]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [TotalOrdDisc]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [TransferAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [WCShipViaID]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT ((0)) FOR [WOAvailAtETA]
GO
ALTER TABLE [dbo].[SOSetup] ADD  DEFAULT (' ') FOR [Zip]
GO
