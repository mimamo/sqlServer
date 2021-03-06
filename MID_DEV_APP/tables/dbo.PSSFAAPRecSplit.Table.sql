USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFAAPRecSplit]    Script Date: 12/21/2015 14:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAPRecSplit](
	[AccessNbr] [int] NOT NULL,
	[APRecLineId] [smallint] NOT NULL,
	[AssetDescr] [char](60) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Custodian] [char](20) NOT NULL,
	[DeprFrom] [smalldatetime] NOT NULL,
	[DeprYN] [char](1) NOT NULL,
	[Dept] [char](24) NOT NULL,
	[DeptYN] [char](1) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LocId] [char](24) NOT NULL,
	[NonFixedAsset] [smallint] NOT NULL,
	[Qty] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Tagno] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ((0)) FOR [APRecLineId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [Custodian]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('01/01/1900') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [DeprYN]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [DeptYN]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [LocId]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ((0)) FOR [NonFixedAsset]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ((0.00)) FOR [Qty]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecSplit] ADD  DEFAULT ('') FOR [Tagno]
GO
