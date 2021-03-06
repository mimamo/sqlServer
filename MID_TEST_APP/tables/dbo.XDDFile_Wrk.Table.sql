USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[XDDFile_Wrk]    Script Date: 12/21/2015 14:26:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDFile_Wrk](
	[AdjCrtd_DateTime] [smalldatetime] NOT NULL,
	[AdjCrtd_Prog] [char](8) NOT NULL,
	[AdjCrtd_User] [char](10) NOT NULL,
	[AdjS4Future01] [char](30) NOT NULL,
	[AdjS4Future02] [char](30) NOT NULL,
	[AdjS4Future03] [float] NOT NULL,
	[AdjS4Future04] [float] NOT NULL,
	[AdjS4Future05] [float] NOT NULL,
	[AdjS4Future06] [float] NOT NULL,
	[AdjS4Future07] [smalldatetime] NOT NULL,
	[AdjS4Future08] [smalldatetime] NOT NULL,
	[AdjS4Future09] [int] NOT NULL,
	[AdjS4Future10] [int] NOT NULL,
	[AdjS4Future11] [char](10) NOT NULL,
	[AdjS4Future12] [char](10) NOT NULL,
	[BnkAcctType] [char](1) NOT NULL,
	[BnkBankAcct] [char](35) NOT NULL,
	[BnkBankTransit] [char](30) NOT NULL,
	[BnkOrigDFI] [char](9) NOT NULL,
	[BnkPNDate] [smalldatetime] NOT NULL,
	[BnkPNStatus] [char](1) NOT NULL,
	[BnkUser1] [char](30) NOT NULL,
	[BnkUser10] [char](30) NOT NULL,
	[BnkUser2] [char](30) NOT NULL,
	[BnkUser3] [float] NOT NULL,
	[BnkUser4] [float] NOT NULL,
	[BnkUser5] [char](10) NOT NULL,
	[BnkUser6] [char](10) NOT NULL,
	[BnkUser7] [smalldatetime] NOT NULL,
	[BnkUser8] [smalldatetime] NOT NULL,
	[BnkUser9] [char](30) NOT NULL,
	[ChkAcct] [char](10) NOT NULL,
	[ChkBatEFTGrp] [smallint] NOT NULL,
	[ChkBatNbr] [char](10) NOT NULL,
	[ChkBatSeq] [smallint] NOT NULL,
	[ChkCpnyID] [char](10) NOT NULL,
	[ChkCuryAmt] [float] NOT NULL,
	[ChkCuryDiscAmt] [float] NOT NULL,
	[ChkCuryID] [char](4) NOT NULL,
	[ChkCuryRGOLAmt] [float] NOT NULL,
	[ChkDocDate] [smalldatetime] NOT NULL,
	[ChkDocType] [char](2) NOT NULL,
	[ChkLUpd_DateTime] [smalldatetime] NOT NULL,
	[ChkLUpd_Prog] [char](8) NOT NULL,
	[ChkLUpd_User] [char](10) NOT NULL,
	[ChkPerPost] [char](6) NOT NULL,
	[ChkRefNbr] [char](10) NOT NULL,
	[ChkSub] [char](24) NOT NULL,
	[ChkTerms] [char](2) NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DepAcctType] [char](1) NOT NULL,
	[DepBankAcct] [char](35) NOT NULL,
	[DepBankAcctLen] [smallint] NOT NULL,
	[DepBankTransit] [char](30) NOT NULL,
	[DepBankTransitLen] [smallint] NOT NULL,
	[DepEDIVersion] [char](6) NOT NULL,
	[DepEntryClass] [char](4) NOT NULL,
	[DepISOCntry] [char](2) NOT NULL,
	[DepPNDate] [smalldatetime] NOT NULL,
	[DepPNStatus] [char](1) NOT NULL,
	[DepPNTaxPmt] [char](15) NOT NULL,
	[DepRecord] [char](1) NOT NULL,
	[DepUser1] [char](30) NOT NULL,
	[DepUser10] [char](30) NOT NULL,
	[DepUser2] [char](30) NOT NULL,
	[DepUser3] [float] NOT NULL,
	[DepUser4] [float] NOT NULL,
	[DepUser5] [char](10) NOT NULL,
	[DepUser6] [char](10) NOT NULL,
	[DepUser7] [smalldatetime] NOT NULL,
	[DepUser8] [smalldatetime] NOT NULL,
	[DepUser9] [char](30) NOT NULL,
	[EBFileNbr] [char](6) NOT NULL,
	[EditScrnNbr] [char](5) NOT NULL,
	[FilACHCompanyID] [char](30) NOT NULL,
	[FilACHCompanyIDLen] [smallint] NOT NULL,
	[FilACHCompanyName] [char](30) NOT NULL,
	[FilACHCompanyNameLen] [smallint] NOT NULL,
	[FilACHImmDest] [char](30) NOT NULL,
	[FilACHImmDestLen] [smallint] NOT NULL,
	[FilACHImmDestN] [char](30) NOT NULL,
	[FilACHImmDestNLen] [smallint] NOT NULL,
	[FilACHImmOrig] [char](30) NOT NULL,
	[FilACHImmOrigLen] [smallint] NOT NULL,
	[FilACHImmOrigN] [char](30) NOT NULL,
	[FilACHImmOrigNLen] [smallint] NOT NULL,
	[FilCrLf] [char](1) NOT NULL,
	[FileType] [char](1) NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[KeepDelete] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerAppl] [char](6) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[RecordSumAmt] [float] NOT NULL,
	[RecordSummary] [char](1) NOT NULL,
	[RecSection] [char](3) NOT NULL,
	[RecType] [char](3) NOT NULL,
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
	[ValueString] [char](255) NOT NULL,
	[VchAmt] [float] NOT NULL,
	[VchAmtInChkCury] [float] NOT NULL,
	[VchCpnyID] [char](10) NOT NULL,
	[VchCpnyIDEIN] [char](12) NOT NULL,
	[VchCuryAmt] [float] NOT NULL,
	[VchCuryDiscAmt] [float] NOT NULL,
	[VchCuryID] [char](4) NOT NULL,
	[VchCuryMultDiv] [char](1) NOT NULL,
	[VchCuryOrigDocAmt] [float] NOT NULL,
	[VchCuryRate] [float] NOT NULL,
	[VchDiscAmt] [float] NOT NULL,
	[VchDocDesc] [char](30) NOT NULL,
	[VchDocType] [char](2) NOT NULL,
	[VchInvcDate] [smalldatetime] NOT NULL,
	[VchInvcNbr] [char](15) NOT NULL,
	[VchPONbr] [char](10) NOT NULL,
	[VchRefNbr] [char](10) NOT NULL,
	[VchUser1] [char](30) NOT NULL,
	[VchUser2] [char](30) NOT NULL,
	[VchUser3] [float] NOT NULL,
	[VchUser4] [float] NOT NULL,
	[VchUser5] [char](10) NOT NULL,
	[VchUser6] [char](10) NOT NULL,
	[VchUser7] [smalldatetime] NOT NULL,
	[VchUser8] [smalldatetime] NOT NULL,
	[VendCust] [char](1) NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VendName] [char](60) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDFile_Wrk0] PRIMARY KEY CLUSTERED 
(
	[FileType] ASC,
	[EBFileNbr] ASC,
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [AdjCrtd_DateTime]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [AdjCrtd_Prog]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [AdjCrtd_User]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [AdjS4Future01]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [AdjS4Future02]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [AdjS4Future03]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [AdjS4Future04]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [AdjS4Future05]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [AdjS4Future06]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [AdjS4Future07]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [AdjS4Future08]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [AdjS4Future09]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [AdjS4Future10]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [AdjS4Future11]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [AdjS4Future12]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkAcctType]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkBankAcct]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkBankTransit]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkOrigDFI]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [BnkPNDate]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkPNStatus]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkUser1]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkUser10]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkUser2]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [BnkUser3]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [BnkUser4]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkUser5]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkUser6]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [BnkUser7]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [BnkUser8]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [BnkUser9]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkAcct]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [ChkBatEFTGrp]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkBatNbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [ChkBatSeq]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkCpnyID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [ChkCuryAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [ChkCuryDiscAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkCuryID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [ChkCuryRGOLAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [ChkDocDate]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkDocType]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [ChkLUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkLUpd_Prog]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkLUpd_User]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkPerPost]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkRefNbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkSub]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ChkTerms]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ComputerName]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepAcctType]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepBankAcct]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [DepBankAcctLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepBankTransit]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [DepBankTransitLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepEDIVersion]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepEntryClass]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepISOCntry]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [DepPNDate]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepPNStatus]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepPNTaxPmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepRecord]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepUser1]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepUser10]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepUser2]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [DepUser3]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [DepUser4]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepUser5]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepUser6]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [DepUser7]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [DepUser8]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [DepUser9]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [EBFileNbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [EditScrnNbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilACHCompanyID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [FilACHCompanyIDLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilACHCompanyName]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [FilACHCompanyNameLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilACHImmDest]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [FilACHImmDestLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilACHImmDestN]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [FilACHImmDestNLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilACHImmOrig]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [FilACHImmOrigLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilACHImmOrigN]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [FilACHImmOrigNLen]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FilCrLf]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FileType]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [KeepDelete]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [PerAppl]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [RecordSumAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [RecordSummary]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [RecSection]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [RecType]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [ValueString]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchAmtInChkCury]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchCpnyID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchCpnyIDEIN]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchCuryAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchCuryDiscAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchCuryID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchCuryMultDiv]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchCuryOrigDocAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchCuryRate]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchDiscAmt]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchDocDesc]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchDocType]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [VchInvcDate]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchInvcNbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchPONbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchRefNbr]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchUser1]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchUser2]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchUser3]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ((0)) FOR [VchUser4]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchUser5]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VchUser6]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [VchUser7]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('01/01/1900') FOR [VchUser8]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VendCust]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VendID]
GO
ALTER TABLE [dbo].[XDDFile_Wrk] ADD  DEFAULT ('') FOR [VendName]
GO
