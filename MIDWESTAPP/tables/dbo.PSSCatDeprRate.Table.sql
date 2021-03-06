USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PSSCatDeprRate]    Script Date: 12/21/2015 15:54:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSCatDeprRate](
	[Acct] [char](10) NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Rate] [float] NOT NULL,
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
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ((0.00)) FOR [Rate]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [SubAcct]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSCatDeprRate] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
