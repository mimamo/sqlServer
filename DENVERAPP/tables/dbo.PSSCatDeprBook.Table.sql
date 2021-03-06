USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSCatDeprBook]    Script Date: 12/21/2015 15:42:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSCatDeprBook](
	[AvgConv] [char](1) NOT NULL,
	[BonusDeprCd] [char](10) NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Depreciate] [char](1) NOT NULL,
	[DeprMethod] [char](20) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MMDays] [smallint] NOT NULL,
	[MMType] [char](1) NOT NULL,
	[Sect] [char](6) NOT NULL,
	[Sect179] [char](1) NOT NULL,
	[UsefulLife] [float] NOT NULL,
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
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [AvgConv]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [BonusDeprCd]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [Depreciate]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ((0)) FOR [MMDays]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [MMType]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [Sect]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [Sect179]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ((0.00)) FOR [UsefulLife]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSCatDeprBook] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
