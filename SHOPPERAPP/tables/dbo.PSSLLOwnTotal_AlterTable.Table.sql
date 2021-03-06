USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSLLOwnTotal_AlterTable]    Script Date: 12/21/2015 16:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLOwnTotal_AlterTable](
	[BeginDate] [smalldatetime] NOT NULL,
	[ClientCode] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[ILID] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[OwnCode] [char](10) NOT NULL,
	[PercOwn] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[SubAcct] [char](24) NOT NULL,
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
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [BeginDate]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [ClientCode]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [ILID]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [OwnCode]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PercOwn]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [SubAcct]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLOwnTotal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
