USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLOwnPmtAcct_AlterTable]    Script Date: 12/21/2015 14:10:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable](
	[CRAcct] [char](10) NOT NULL,
	[CRSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DefaultAmt] [float] NOT NULL,
	[DRAcct] [char](10) NOT NULL,
	[DRSub] [char](24) NOT NULL,
	[GroupWriteOff] [char](47) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[OwnCode] [char](10) NOT NULL,
	[PmtType] [char](3) NOT NULL,
	[PmtTypeCode] [char](10) NOT NULL,
	[PmtTypeDescr] [char](60) NOT NULL,
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
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [CRAcct]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [CRSub]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ((0.00)) FOR [DefaultAmt]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [DRAcct]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [DRSub]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [GroupWriteOff]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [OwnCode]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [PmtType]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [PmtTypeCode]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [PmtTypeDescr]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLOwnPmtAcct_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
