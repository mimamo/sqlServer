USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSLIAcctOwn]    Script Date: 12/21/2015 15:42:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLIAcctOwn](
	[Account] [char](50) NOT NULL,
	[AcctTitle] [char](255) NOT NULL,
	[AcctType] [char](1) NOT NULL,
	[AcctTypeCode] [char](6) NOT NULL,
	[AppComplete] [smallint] NOT NULL,
	[Attn] [char](100) NOT NULL,
	[Beneficiary] [char](100) NOT NULL,
	[BeneficiaryDate] [smalldatetime] NOT NULL,
	[Broker] [char](10) NOT NULL,
	[BrokerPerc] [float] NOT NULL,
	[ClassCode] [char](5) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustodianCode] [char](6) NOT NULL,
	[DateClosed] [smalldatetime] NOT NULL,
	[DateOpened] [smalldatetime] NOT NULL,
	[FundCode] [char](10) NOT NULL,
	[IRAAccount] [char](60) NOT NULL,
	[IRADescr] [char](30) NOT NULL,
	[JointInvestor] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PrimInvestor] [char](10) NOT NULL,
	[ReducedFee] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxId] [char](11) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendorId] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Account]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [AcctTitle]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [AcctType]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [AcctTypeCode]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ((0)) FOR [AppComplete]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Attn]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Beneficiary]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [BeneficiaryDate]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Broker]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ((0.00)) FOR [BrokerPerc]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [ClassCode]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [CustodianCode]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [DateClosed]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [DateOpened]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [FundCode]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [IRAAccount]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [IRADescr]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [JointInvestor]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [PrimInvestor]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ((0)) FOR [ReducedFee]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [TaxId]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSLIAcctOwn] ADD  DEFAULT ('') FOR [VendorId]
GO
