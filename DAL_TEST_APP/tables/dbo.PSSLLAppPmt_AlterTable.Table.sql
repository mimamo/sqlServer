USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLAppPmt_AlterTable]    Script Date: 12/21/2015 13:56:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLAppPmt_AlterTable](
	[BatNbr] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[PmtNbr] [smallint] NOT NULL,
	[PmtType] [char](3) NOT NULL,
	[PmtTypeCode] [char](10) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [PmtType]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [PmtTypeCode]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLAppPmt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
