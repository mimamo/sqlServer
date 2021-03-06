USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[XDDFileFormat]    Script Date: 12/21/2015 16:12:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDFileFormat](
	[AcctNbrNotReqd] [smallint] NOT NULL,
	[AcctTypeTitle] [char](30) NOT NULL,
	[BankAcctLen] [smallint] NOT NULL,
	[BankTransitCDigit] [smallint] NOT NULL,
	[BankTransitLen] [smallint] NOT NULL,
	[BankTransitNotReqd] [smallint] NOT NULL,
	[BankTransitTitle] [char](30) NOT NULL,
	[BEDesc01] [char](30) NOT NULL,
	[BEDesc02] [char](30) NOT NULL,
	[BEMask01] [char](30) NOT NULL,
	[BEMask02] [char](30) NOT NULL,
	[BlockFill] [smallint] NOT NULL,
	[CompanyIDMask] [char](30) NOT NULL,
	[CompanyIDTitle] [char](30) NOT NULL,
	[CompanyNameMask] [char](30) NOT NULL,
	[CompanyNameTitle] [char](30) NOT NULL,
	[CrLf] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[EffDateOffSet] [smallint] NOT NULL,
	[EntryClassTitle] [char](30) NOT NULL,
	[EntryClassDescrMask] [char](20) NOT NULL,
	[EntryClassUserField] [smallint] NOT NULL,
	[EntryClassUserFldAR] [smallint] NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[FormatType] [char](1) NOT NULL,
	[HTNotes] [char](255) NOT NULL,
	[HTRecord] [smallint] NOT NULL,
	[ImmDestMask] [char](30) NOT NULL,
	[ImmDestNameMask] [char](30) NOT NULL,
	[ImmDestNameTitle] [char](30) NOT NULL,
	[ImmDestTitle] [char](30) NOT NULL,
	[ImmOrigNameMask] [char](30) NOT NULL,
	[ImmOrigNameTitle] [char](30) NOT NULL,
	[ImmOrigMask] [char](30) NOT NULL,
	[ImmOrigTitle] [char](30) NOT NULL,
	[InclCOCredit] [smallint] NOT NULL,
	[InclCODebit] [smallint] NOT NULL,
	[KeepDelete] [char](1) NOT NULL,
	[LastEffDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MultiLineToken] [char](1) NOT NULL,
	[NextDailyReset] [smallint] NOT NULL,
	[NextDailyResetDate] [smalldatetime] NOT NULL,
	[NextFileID] [int] NOT NULL,
	[NextSeqNum] [int] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PreNote] [smallint] NOT NULL,
	[PreNoteDays] [smallint] NOT NULL,
	[RecordLen] [smallint] NOT NULL,
	[Selected] [char](1) NOT NULL,
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
	[TaxPayment] [smallint] NOT NULL,
	[TrimRecord] [smallint] NOT NULL,
	[TwoFileNameAddition] [char](10) NOT NULL,
	[TwoFileSepString] [char](20) NOT NULL,
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
	[WBank01Descr] [char](30) NOT NULL,
	[WBank01Mask] [char](35) NOT NULL,
	[WBank01Reqd] [smallint] NOT NULL,
	[WBank02Descr] [char](30) NOT NULL,
	[WBank02Mask] [char](35) NOT NULL,
	[WBank02Reqd] [smallint] NOT NULL,
	[WBank03Descr] [char](30) NOT NULL,
	[WBank03Mask] [char](35) NOT NULL,
	[WBank03Reqd] [smallint] NOT NULL,
	[WBank04Descr] [char](30) NOT NULL,
	[WBank04Mask] [char](35) NOT NULL,
	[WBank04Reqd] [smallint] NOT NULL,
	[WBenAdvicePV] [char](100) NOT NULL,
	[WBenBankAcctTypePV] [char](255) NOT NULL,
	[WBenBankAdvicePV] [char](100) NOT NULL,
	[WBenBankInstCodePV] [char](100) NOT NULL,
	[WBenBankQualPV] [char](255) NOT NULL,
	[WBeneAcctTypePV] [char](255) NOT NULL,
	[WBenMailHandlePV] [char](100) NOT NULL,
	[WChargesIndicPV] [char](100) NOT NULL,
	[WChkCrossCodePV] [char](100) NOT NULL,
	[WChkForwardCodePV] [char](100) NOT NULL,
	[WCorresCostCodePV] [char](100) NOT NULL,
	[WCrePartyAdvicePV] [char](100) NOT NULL,
	[WCrePartyAcctTypePV] [char](100) NOT NULL,
	[WCtryQualifierPV] [char](100) NOT NULL,
	[WDomCostCodePV] [char](100) NOT NULL,
	[WIntBankQualifierPV] [char](255) NOT NULL,
	[WOtherPriorityPV] [char](100) NOT NULL,
	[WPmtCategCodePV] [char](100) NOT NULL,
	[WPmtMethodCodePV] [char](100) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDFileFormat0] PRIMARY KEY CLUSTERED 
(
	[FormatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [AcctNbrNotReqd]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [AcctTypeTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [BankAcctLen]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [BankTransitCDigit]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [BankTransitLen]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [BankTransitNotReqd]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [BankTransitTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [BEDesc01]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [BEDesc02]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [BEMask01]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [BEMask02]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [BlockFill]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [CompanyIDMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [CompanyIDTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [CompanyNameMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [CompanyNameTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [CrLf]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [EffDateOffSet]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [EntryClassTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [EntryClassDescrMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [EntryClassUserField]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [EntryClassUserFldAR]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [FormatType]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [HTNotes]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [HTRecord]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmDestMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmDestNameMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmDestNameTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmDestTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmOrigNameMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmOrigNameTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmOrigMask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [ImmOrigTitle]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [InclCOCredit]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [InclCODebit]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [KeepDelete]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [LastEffDate]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [MultiLineToken]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [NextDailyReset]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [NextDailyResetDate]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [NextFileID]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [NextSeqNum]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [PreNote]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [PreNoteDays]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [RecordLen]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [Selected]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [TaxPayment]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [TrimRecord]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [TwoFileNameAddition]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [TwoFileSepString]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank01Descr]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank01Mask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank01Reqd]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank02Descr]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank02Mask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank02Reqd]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank03Descr]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank03Mask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank03Reqd]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank04Descr]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank04Mask]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBank04Reqd]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBenAdvicePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBenBankAcctTypePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBenBankAdvicePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBenBankInstCodePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBenBankQualPV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBeneAcctTypePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WBenMailHandlePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WChargesIndicPV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WChkCrossCodePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WChkForwardCodePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WCorresCostCodePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WCrePartyAdvicePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WCrePartyAcctTypePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WCtryQualifierPV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WDomCostCodePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WIntBankQualifierPV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WOtherPriorityPV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WPmtCategCodePV]
GO
ALTER TABLE [dbo].[XDDFileFormat] ADD  DEFAULT ('') FOR [WPmtMethodCodePV]
GO
