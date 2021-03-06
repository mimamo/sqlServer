USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSLoanAuthMatrix]    Script Date: 12/21/2015 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLoanAuthMatrix](
	[AuthGroup] [char](47) NOT NULL,
	[AuthReq] [smallint] NOT NULL,
	[ConvertToLoan] [int] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DaysAtStatus] [smallint] NOT NULL,
	[EndLoanValue] [float] NOT NULL,
	[EndNbrPer] [smallint] NOT NULL,
	[GroupEmail] [char](47) NOT NULL,
	[Level] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LoanTypeCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[StartLoanValue] [float] NOT NULL,
	[StartNbrPer] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WorkDate] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [AuthGroup]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [AuthReq]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [ConvertToLoan]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [DaysAtStatus]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0.00)) FOR [EndLoanValue]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [EndNbrPer]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [GroupEmail]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [LoanTypeCode]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0.00)) FOR [StartLoanValue]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0)) FOR [StartNbrPer]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSLoanAuthMatrix] ADD  DEFAULT ('01/01/1900') FOR [WorkDate]
GO
