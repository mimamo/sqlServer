USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PSSFAAssetCat]    Script Date: 12/21/2015 15:54:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAssetCat](
	[AccDeprAcct] [char](10) NOT NULL,
	[AccDeprSubAcct] [char](24) NOT NULL,
	[Acct] [char](10) NOT NULL,
	[CatDescr] [char](30) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeprExpAcct] [char](10) NOT NULL,
	[DeprExpSubAcct] [char](24) NOT NULL,
	[DeprFrom] [char](1) NOT NULL,
	[DeprFromDays] [smallint] NOT NULL,
	[DeprFromFirst] [char](1) NOT NULL,
	[GainLossAcct] [char](10) NOT NULL,
	[GainLossSubAcct] [char](24) NOT NULL,
	[ImpairmentAcct] [char](10) NOT NULL,
	[ImpairmentSubAcct] [char](24) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TangbLineNbr] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [AccDeprAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [AccDeprSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [CatDescr]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [DeprExpAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [DeprExpSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ((0)) FOR [DeprFromDays]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [DeprFromFirst]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [GainLossAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [GainLossSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [ImpairmentAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [ImpairmentSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ((0)) FOR [TangbLineNbr]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ((0.00)) FOR [UsefulLife]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFAAssetCat] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
