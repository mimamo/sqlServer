USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[XDDDepositor]    Script Date: 12/21/2015 13:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDDepositor](
	[AcctAppLUpd_App] [char](10) NOT NULL,
	[AcctAppLUpd_AppDT] [smalldatetime] NOT NULL,
	[AcctAppLUpd_Chg] [char](10) NOT NULL,
	[AcctAppLUpd_ChgDT] [smalldatetime] NOT NULL,
	[AcctAppStatus] [char](1) NOT NULL,
	[AcctType] [char](1) NOT NULL,
	[BankAcct] [char](35) NOT NULL,
	[BankAcctOld] [char](35) NOT NULL,
	[BankTransit] [char](30) NOT NULL,
	[BankTransitOld] [char](30) NOT NULL,
	[BE01] [char](30) NOT NULL,
	[BE02] [char](30) NOT NULL,
	[ConvertCCDP_CCD] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EDIVersion] [char](6) NOT NULL,
	[EM1Vendor] [char](1) NOT NULL,
	[EM1ToCcBc] [char](1) NOT NULL,
	[EM2Addr] [char](128) NOT NULL,
	[EM2Name] [char](128) NOT NULL,
	[EM2ToCcBc] [char](1) NOT NULL,
	[EM3Addr] [char](128) NOT NULL,
	[EM3Name] [char](128) NOT NULL,
	[EM3ToCcBc] [char](1) NOT NULL,
	[EM4Addr] [char](128) NOT NULL,
	[EM4Name] [char](128) NOT NULL,
	[EM4ToCcBc] [char](1) NOT NULL,
	[EMAttachFExt] [char](10) NOT NULL,
	[EMAttachFF] [char](1) NOT NULL,
	[EMAttachFN] [char](50) NOT NULL,
	[EMAttachFND] [smallint] NOT NULL,
	[EMAttachFNI] [smallint] NOT NULL,
	[EMAttachFNote] [char](100) NOT NULL,
	[EMAttachFRL] [smallint] NOT NULL,
	[EMAttachFromSetup] [smallint] NOT NULL,
	[EMAttachInclBMsg] [smallint] NOT NULL,
	[EMAttachInclTMsg] [smallint] NOT NULL,
	[EMAttachNbrDocs] [smallint] NOT NULL,
	[EMAttachSP] [char](50) NOT NULL,
	[EMAttachUse] [smallint] NOT NULL,
	[EMAPTran] [char](1) NOT NULL,
	[EMAPTranUseCo] [smallint] NOT NULL,
	[EMNotification] [char](1) NOT NULL,
	[EMPriority] [int] NOT NULL,
	[EMPriorityUseCo] [smallint] NOT NULL,
	[EMReplyToAddr] [char](128) NOT NULL,
	[EMReplyToName] [char](128) NOT NULL,
	[EMReplyToUseCo] [smallint] NOT NULL,
	[EMSubject] [char](128) NOT NULL,
	[EMSubjectUseCo] [smallint] NOT NULL,
	[EntryClass] [char](4) NOT NULL,
	[EntryClassCanChg] [smallint] NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[FromLBImport] [smallint] NOT NULL,
	[LBApplicMethod] [char](2) NOT NULL,
	[LBBankAcct] [char](30) NOT NULL,
	[LBBankTransit] [char](30) NOT NULL,
	[LBImportDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PNDate] [smalldatetime] NOT NULL,
	[PNStatus] [char](1) NOT NULL,
	[PNTaxPmt] [char](15) NOT NULL,
	[Record] [char](1) NOT NULL,
	[SKFuture01] [char](30) NOT NULL,
	[SKFuture02] [char](30) NOT NULL,
	[SKFuture03] [float] NOT NULL,
	[SKFuture04] [float] NOT NULL,
	[SKFuture05] [float] NOT NULL,
	[SKFuture06] [float] NOT NULL,
	[SKFuture07] [smalldatetime] NOT NULL,
	[SKFuture08] [smalldatetime] NOT NULL,
	[SKFuture09] [int] NOT NULL,
	[SKFuture10] [int] NOT NULL,
	[SKFuture11] [char](10) NOT NULL,
	[SKFuture12] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TermDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[VendCust] [char](1) NOT NULL,
	[VendID] [char](15) NOT NULL,
	[WBankInst1] [char](35) NOT NULL,
	[WBankInst2] [char](35) NOT NULL,
	[WBankInst3] [char](35) NOT NULL,
	[WBankInst4] [char](35) NOT NULL,
	[WBankInst5] [char](35) NOT NULL,
	[WBankInst6] [char](35) NOT NULL,
	[WBenBankAcct] [char](35) NOT NULL,
	[WBenBankAcctType] [char](1) NOT NULL,
	[WBenBankAddr] [char](35) NOT NULL,
	[WBenBankAdvice] [char](1) NOT NULL,
	[WBenBankBranch] [char](70) NOT NULL,
	[WBenBankCity] [char](35) NOT NULL,
	[WBenBankCountry] [char](35) NOT NULL,
	[WBenBankID] [char](12) NOT NULL,
	[WBenBankIDOld] [char](12) NOT NULL,
	[WBenBankInstCode] [char](10) NOT NULL,
	[WBenBankInstruction] [char](150) NOT NULL,
	[WBenBankISOCntry] [char](3) NOT NULL,
	[WBenBankName] [char](70) NOT NULL,
	[WBenBankQualifier] [char](2) NOT NULL,
	[WBenBankSwift] [char](11) NOT NULL,
	[WBenBankSwiftOld] [char](11) NOT NULL,
	[WBeneAcct] [char](35) NOT NULL,
	[WBeneAcctOld] [char](35) NOT NULL,
	[WBeneAcctType] [char](1) NOT NULL,
	[WBeneAddr] [char](35) NOT NULL,
	[WBeneAddr2] [char](35) NOT NULL,
	[WBeneAdvice] [char](1) NOT NULL,
	[WBeneCity] [char](35) NOT NULL,
	[WBeneCountry] [char](35) NOT NULL,
	[WBeneISOCntry] [char](3) NOT NULL,
	[WBeneMailHandling] [char](2) NOT NULL,
	[WBeneName] [char](70) NOT NULL,
	[WBeneRemitDtl1] [char](35) NOT NULL,
	[WBeneRemitDtl2] [char](35) NOT NULL,
	[WBeneState] [char](3) NOT NULL,
	[WBeneUseVendorRemit] [smallint] NOT NULL,
	[WBeneZipPostal] [char](11) NOT NULL,
	[WChargesIndic] [char](1) NOT NULL,
	[WChkCrossCode] [char](1) NOT NULL,
	[WChkForwardCode] [char](1) NOT NULL,
	[WCorresCostCode] [smallint] NOT NULL,
	[WCreBankID] [char](9) NOT NULL,
	[WCreBankName] [char](35) NOT NULL,
	[WCrePartyAcct] [char](35) NOT NULL,
	[WCrePartyAcctType] [char](1) NOT NULL,
	[WCrePartyAddr] [char](35) NOT NULL,
	[WCrePartyAdvice] [char](1) NOT NULL,
	[WCrePartyCity] [char](35) NOT NULL,
	[WCrePartyCountry] [char](35) NOT NULL,
	[WCrePartyISOCntry] [char](3) NOT NULL,
	[WCrePartyName] [char](35) NOT NULL,
	[WCrePartySwift] [char](11) NOT NULL,
	[WCtryQualifier] [char](10) NOT NULL,
	[WCtryText] [char](35) NOT NULL,
	[WDomCostCode] [smallint] NOT NULL,
	[WIntBankAcct] [char](35) NOT NULL,
	[WIntBankAddr] [char](35) NOT NULL,
	[WIntBankAddr2] [char](35) NOT NULL,
	[WIntBankBranch] [char](12) NOT NULL,
	[WIntBankCity] [char](35) NOT NULL,
	[WIntBankCountry] [char](35) NOT NULL,
	[WIntBankID] [char](15) NOT NULL,
	[WIntBankISOCntry] [char](3) NOT NULL,
	[WIntBankName] [char](35) NOT NULL,
	[WIntBankQualifier] [char](3) NOT NULL,
	[WIntBankSwift] [char](11) NOT NULL,
	[WPmtCategCode] [char](1) NOT NULL,
	[WPmtInstCode1] [char](4) NOT NULL,
	[WPmtInstCode2] [char](4) NOT NULL,
	[WPmtInstCode3] [char](4) NOT NULL,
	[WPmtInstCode4] [char](4) NOT NULL,
	[WPmtInstText1] [char](35) NOT NULL,
	[WPmtInstText2] [char](35) NOT NULL,
	[WPmtInstText3] [char](35) NOT NULL,
	[WPmtInstText4] [char](35) NOT NULL,
	[WPmtMethodCode] [smallint] NOT NULL,
	[WProcCode] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDDepositor0] PRIMARY KEY CLUSTERED 
(
	[VendID] ASC,
	[VendCust] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [AcctAppLUpd_App]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [AcctAppLUpd_AppDT]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [AcctAppLUpd_Chg]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [AcctAppLUpd_ChgDT]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [AcctAppStatus]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [AcctType]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [BankAcct]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [BankAcctOld]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [BankTransit]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [BankTransitOld]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [BE01]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [BE02]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [ConvertCCDP_CCD]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EDIVersion]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM1Vendor]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM1ToCcBc]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM2Addr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM2Name]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM2ToCcBc]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM3Addr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM3Name]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM3ToCcBc]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM4Addr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM4Name]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EM4ToCcBc]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMAttachFExt]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMAttachFF]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMAttachFN]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachFND]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachFNI]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMAttachFNote]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachFRL]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachFromSetup]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachInclBMsg]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachInclTMsg]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachNbrDocs]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMAttachSP]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAttachUse]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMAPTran]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMAPTranUseCo]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMNotification]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMPriority]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMPriorityUseCo]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMReplyToAddr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMReplyToName]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMReplyToUseCo]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EMSubject]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EMSubjectUseCo]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [EntryClass]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [EntryClassCanChg]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [FromLBImport]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [LBApplicMethod]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [LBBankAcct]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [LBBankTransit]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [LBImportDate]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [PNDate]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [PNStatus]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [PNTaxPmt]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [Record]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [TermDate]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [VendCust]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [VendID]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBankInst1]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBankInst2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBankInst3]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBankInst4]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBankInst5]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBankInst6]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankAcct]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankAcctType]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankAddr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankAdvice]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankBranch]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankCity]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankCountry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankID]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankIDOld]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankInstCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankInstruction]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankISOCntry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankName]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankQualifier]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankSwift]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBenBankSwiftOld]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneAcct]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneAcctOld]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneAcctType]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneAddr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneAddr2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneAdvice]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneCity]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneCountry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneISOCntry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneMailHandling]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneName]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneRemitDtl1]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneRemitDtl2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneState]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [WBeneUseVendorRemit]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WBeneZipPostal]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WChargesIndic]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WChkCrossCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WChkForwardCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [WCorresCostCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCreBankID]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCreBankName]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyAcct]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyAcctType]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyAddr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyAdvice]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyCity]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyCountry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyISOCntry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartyName]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCrePartySwift]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCtryQualifier]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WCtryText]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [WDomCostCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankAcct]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankAddr]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankAddr2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankBranch]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankCity]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankCountry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankID]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankISOCntry]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankName]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankQualifier]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WIntBankSwift]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtCategCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstCode1]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstCode2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstCode3]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstCode4]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstText1]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstText2]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstText3]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WPmtInstText4]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ((0)) FOR [WPmtMethodCode]
GO
ALTER TABLE [dbo].[XDDDepositor] ADD  DEFAULT ('') FOR [WProcCode]
GO
