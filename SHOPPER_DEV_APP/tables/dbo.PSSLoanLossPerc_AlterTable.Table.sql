USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSLoanLossPerc_AlterTable]    Script Date: 12/21/2015 14:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLoanLossPerc_AlterTable](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[EndMonth] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LoanLossCode] [char](15) NOT NULL,
	[LossPerc] [float] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[ReportHeader] [char](60) NOT NULL,
	[StartMonth] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0)) FOR [EndMonth]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [LoanLossCode]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0.00)) FOR [LossPerc]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [ReportHeader]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0)) FOR [StartMonth]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLoanLossPerc_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
