USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[SO40170_Wrk]    Script Date: 12/21/2015 14:16:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SO40170_Wrk](
	[APContact] [char](60) NOT NULL,
	[APPhone] [char](30) NOT NULL,
	[ARAcct] [char](10) NOT NULL,
	[ARBal] [float] NOT NULL,
	[ARSub] [char](24) NOT NULL,
	[AuthNbr] [char](20) NOT NULL,
	[BillAddr1] [char](60) NOT NULL,
	[BillAddr2] [char](60) NOT NULL,
	[BillAddrSpecial] [smallint] NOT NULL,
	[BillAttn] [char](30) NOT NULL,
	[BillCity] [char](30) NOT NULL,
	[BillCountry] [char](3) NOT NULL,
	[BillName] [char](60) NOT NULL,
	[BillState] [char](3) NOT NULL,
	[BillZip] [char](10) NOT NULL,
	[BlktOrdNbr] [char](15) NOT NULL,
	[BuildInvtID] [char](30) NOT NULL,
	[BuildQty] [float] NOT NULL,
	[BuyerID] [char](10) NOT NULL,
	[BuyerName] [char](60) NOT NULL,
	[Cancelled] [smallint] NOT NULL,
	[CertID] [char](2) NOT NULL,
	[CertNoteID] [int] NOT NULL,
	[CmmnPct] [float] NOT NULL,
	[ContractNbr] [char](30) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreditApprDays] [smallint] NOT NULL,
	[CreditApprLimit] [float] NOT NULL,
	[CreditChk] [smallint] NOT NULL,
	[CreditHold] [smallint] NOT NULL,
	[CreditHoldDate] [smalldatetime] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPremFrtAmt] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTotInvc] [float] NOT NULL,
	[CuryTotLineDisc] [float] NOT NULL,
	[CuryTotMerch] [float] NOT NULL,
	[CuryTotMisc] [float] NOT NULL,
	[CuryTotPmt] [float] NOT NULL,
	[CuryTotTax] [float] NOT NULL,
	[CuryTotTxbl] [float] NOT NULL,
	[CuryWholeOrdDisc] [float] NOT NULL,
	[CustGLClassID] [char](4) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustOrdNbr] [char](25) NOT NULL,
	[DateCancelled] [smalldatetime] NOT NULL,
	[Dept] [char](30) NOT NULL,
	[DiscPct] [float] NOT NULL,
	[Div] [char](30) NOT NULL,
	[EDI810] [smallint] NOT NULL,
	[EDI856] [smallint] NOT NULL,
	[FOBID] [char](15) NOT NULL,
	[FrtCollect] [smallint] NOT NULL,
	[FrtTermsID] [char](10) NOT NULL,
	[GeoCode] [char](10) NOT NULL,
	[LanguageID] [char](4) NOT NULL,
	[LineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MarkTo] [smallint] NOT NULL,
	[MiscChrgCntr] [smallint] NOT NULL,
	[NextFunctionClass] [char](4) NOT NULL,
	[NextFunctionID] [char](8) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdDate] [smalldatetime] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[PmtCntr] [smallint] NOT NULL,
	[Priority] [smallint] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Release] [smallint] NOT NULL,
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
	[ShipAddr1] [char](60) NOT NULL,
	[ShipAddr2] [char](60) NOT NULL,
	[ShipAddrID] [char](10) NOT NULL,
	[ShipAddrSpecial] [smallint] NOT NULL,
	[ShipAttn] [char](30) NOT NULL,
	[ShipCity] [char](30) NOT NULL,
	[ShipCmplt] [smallint] NOT NULL,
	[ShipCountry] [char](3) NOT NULL,
	[ShipCustID] [char](15) NOT NULL,
	[ShipGeoCode] [char](10) NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[ShipSiteID] [char](10) NOT NULL,
	[ShipState] [char](3) NOT NULL,
	[ShiptoID] [char](10) NOT NULL,
	[ShiptoType] [char](1) NOT NULL,
	[ShipVendID] [char](15) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[SOTypeID] [char](4) NOT NULL,
	[SpecOrd] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TermsID] [char](2) NOT NULL,
	[TotCommCost] [float] NOT NULL,
	[TotCost] [float] NOT NULL,
	[TotInvc] [float] NOT NULL,
	[TotLineDisc] [float] NOT NULL,
	[TotMerch] [float] NOT NULL,
	[TotMisc] [float] NOT NULL,
	[TotOpenOrd] [float] NOT NULL,
	[TotPmt] [float] NOT NULL,
	[TotShipWght] [float] NOT NULL,
	[TotTax] [float] NOT NULL,
	[TotTxbl] [float] NOT NULL,
	[Type] [char](1) NOT NULL,
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
	[WeekendDelivery] [smallint] NOT NULL,
	[WholeOrdDisc] [float] NOT NULL,
	[WorkflowID] [int] NOT NULL,
	[WorkflowStatus] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [APContact]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [APPhone]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ARAcct]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [ARBal]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ARSub]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [AuthNbr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillAddr1]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillAddr2]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [BillAddrSpecial]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillAttn]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillCity]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillCountry]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillName]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillState]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BillZip]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BlktOrdNbr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BuildInvtID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [BuildQty]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BuyerID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [BuyerName]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CertID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CertNoteID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CmmnPct]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ContractNbr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CreditApprDays]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CreditApprLimit]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CreditChk]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CreditHold]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [CreditHoldDate]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryPremFrtAmt]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotInvc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotLineDisc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotMerch]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotMisc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotPmt]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotTax]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryTotTxbl]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [CuryWholeOrdDisc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CustGLClassID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [CustOrdNbr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [DateCancelled]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [Dept]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [Div]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [EDI810]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [EDI856]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [FOBID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [FrtCollect]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [FrtTermsID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [GeoCode]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [LanguageID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [MarkTo]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [MiscChrgCntr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [NextFunctionClass]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [NextFunctionID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [OrdDate]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [PmtCntr]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [Release]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipAddrID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [ShipAddrSpecial]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipAttn]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [ShipCmplt]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipCustID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipGeoCode]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipSiteID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShiptoID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShiptoType]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipVendID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [SpecOrd]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [TermsID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotCommCost]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotInvc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotLineDisc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotMerch]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotMisc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotOpenOrd]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotPmt]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotShipWght]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotTax]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [TotTxbl]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [Type]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [WeekendDelivery]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [WholeOrdDisc]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT ((0)) FOR [WorkflowID]
GO
ALTER TABLE [dbo].[SO40170_Wrk] ADD  DEFAULT (' ') FOR [WorkflowStatus]
GO
