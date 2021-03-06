USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSLoanStatus]    Script Date: 12/21/2015 14:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLoanStatus](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateEntStat] [smalldatetime] NOT NULL,
	[DateLeftStat] [smalldatetime] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StatusCode] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UserChgFromStat] [char](30) NOT NULL,
	[UserChgToStat] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('01/01/1900') FOR [DateEntStat]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('01/01/1900') FOR [DateLeftStat]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [StatusCode]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [UserChgFromStat]
GO
ALTER TABLE [dbo].[PSSLoanStatus] ADD  DEFAULT ('') FOR [UserChgToStat]
GO
