USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSEscrow]    Script Date: 12/21/2015 14:05:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSEscrow](
	[AcctId] [char](10) NOT NULL,
	[AcctNo] [char](20) NOT NULL,
	[AcctType] [char](1) NOT NULL,
	[CloseDate] [smalldatetime] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustodianCode] [char](10) NOT NULL,
	[EscrowAcct] [char](10) NOT NULL,
	[EscrowBal] [float] NOT NULL,
	[EscrowCRAcct] [char](10) NOT NULL,
	[EscrowCRSub] [char](24) NOT NULL,
	[EscrowDRAcct] [char](10) NOT NULL,
	[EscrowDRSub] [char](24) NOT NULL,
	[EscrowPmt] [float] NOT NULL,
	[EscrowSub] [char](24) NOT NULL,
	[LastChkNbr] [char](10) NOT NULL,
	[LastDepNbr] [char](10) NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MailAddr1] [char](30) NOT NULL,
	[MailAddr2] [char](30) NOT NULL,
	[MailCity] [char](30) NOT NULL,
	[MailState] [char](2) NOT NULL,
	[MailZipCode] [char](10) NOT NULL,
	[MICRAcctNoChk] [char](30) NOT NULL,
	[MICRAcctNoDep] [char](30) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenDate] [smalldatetime] NOT NULL,
	[SSN] [char](9) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxID] [char](9) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [AcctId]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [AcctNo]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [AcctType]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('01/01/1900') FOR [CloseDate]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [CustodianCode]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [EscrowAcct]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ((0.00)) FOR [EscrowBal]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [EscrowCRAcct]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [EscrowCRSub]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [EscrowDRAcct]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [EscrowDRSub]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ((0.00)) FOR [EscrowPmt]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [EscrowSub]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [LastChkNbr]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [LastDepNbr]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MailAddr1]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MailAddr2]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MailCity]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MailState]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MailZipCode]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MICRAcctNoChk]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [MICRAcctNoDep]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('01/01/1900') FOR [OpenDate]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [SSN]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [TaxID]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSEscrow] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
