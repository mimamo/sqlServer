USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSFATempBatch]    Script Date: 12/21/2015 16:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATempBatch](
	[AccessNbr] [smallint] NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[LedgerId] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[ScrnNbr] [char](5) NOT NULL,
	[TranBatnbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [LedgerId]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [ScrnNbr]
GO
ALTER TABLE [dbo].[PSSFATempBatch] ADD  DEFAULT ('') FOR [TranBatnbr]
GO
