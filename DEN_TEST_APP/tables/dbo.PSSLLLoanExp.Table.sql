USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLLoanExp]    Script Date: 12/21/2015 14:10:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLLoanExp](
	[AmortCrAcct] [char](10) NOT NULL,
	[AmortCrSub] [char](24) NOT NULL,
	[AmortDrAcct] [char](10) NOT NULL,
	[AmortDrSub] [char](24) NOT NULL,
	[AmtAmortDate] [float] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CrSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSub] [char](24) NOT NULL,
	[ExpType] [char](1) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PmtTypeCode] [char](10) NOT NULL,
	[Recurrs] [char](1) NOT NULL,
	[RecurrsTimes] [smallint] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Status] [char](24) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
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
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [AmortCrAcct]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [AmortCrSub]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [AmortDrAcct]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [AmortDrSub]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ((0.00)) FOR [AmtAmortDate]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [CrSub]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [DrSub]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [ExpType]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [PmtTypeCode]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [Recurrs]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ((0)) FOR [RecurrsTimes]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLLoanExp] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
