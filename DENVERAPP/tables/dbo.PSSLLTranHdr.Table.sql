USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSLLTranHdr]    Script Date: 12/21/2015 15:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLTranHdr](
	[BatNbr] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[Source] [char](1) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TranDescr] [char](60) NOT NULL,
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
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [Source]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [TranDescr]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLTranHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
