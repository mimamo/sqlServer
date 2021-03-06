USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFARecon_AlterTable]    Script Date: 12/21/2015 14:33:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFARecon_AlterTable](
	[Acct] [char](10) NOT NULL,
	[AcctDescr] [char](30) NOT NULL,
	[AcctType] [char](1) NOT NULL,
	[Amt] [float] NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[BookDescr] [char](60) NOT NULL,
	[BookPostGL] [smallint] NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CuryAmt] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[DeprMethod] [char](20) NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[GLLineId] [smallint] NOT NULL,
	[LineID] [smallint] NOT NULL,
	[ModuleID] [char](2) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectId] [char](30) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[SubDescr] [char](30) NOT NULL,
	[TaskId] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](60) NOT NULL,
	[TranType] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [AcctDescr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [AcctType]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ((0.00)) FOR [Amt]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [BookDescr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ((0)) FOR [BookPostGL]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ((0.00)) FOR [CuryAmt]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [CuryID]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [DrCr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ((0)) FOR [GLLineId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [ModuleID]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [ProjectId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [SubDescr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [TaskId]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [TranDescr]
GO
ALTER TABLE [dbo].[PSSFARecon_AlterTable] ADD  DEFAULT ('') FOR [TranType]
GO
