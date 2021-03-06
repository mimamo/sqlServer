USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSLILetterCode]    Script Date: 12/21/2015 14:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLILetterCode](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Ending] [char](60) NOT NULL,
	[LetterCode] [char](20) NOT NULL,
	[LetterDescr] [char](60) NOT NULL,
	[LetterPrt1] [char](255) NOT NULL,
	[LetterPrt1b] [char](255) NOT NULL,
	[LetterPrt2] [char](255) NOT NULL,
	[LetterPrt2b] [char](255) NOT NULL,
	[LetterReport] [char](60) NOT NULL,
	[LetterSig] [char](60) NOT NULL,
	[LetterSigTitle] [char](60) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoCopies] [smallint] NOT NULL,
	[PostScript] [char](255) NOT NULL,
	[Salutation] [char](120) NOT NULL,
	[Signature] [char](120) NOT NULL,
	[SignorTitle] [char](60) NOT NULL,
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
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [Ending]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterCode]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterDescr]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterPrt1]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterPrt1b]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterPrt2]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterPrt2b]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterReport]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterSig]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LetterSigTitle]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ((0)) FOR [NoCopies]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [PostScript]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [Salutation]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [Signature]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [SignorTitle]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLILetterCode] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
