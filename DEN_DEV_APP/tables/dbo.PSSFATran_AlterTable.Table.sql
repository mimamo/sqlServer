USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFATran_AlterTable]    Script Date: 12/21/2015 14:05:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATran_AlterTable](
	[Amt] [float] NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BaseCuryID] [char](4) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[BookSeq] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CrSubAcct] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAmt] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[DeprMethod] [char](20) NOT NULL,
	[DispTran] [char](1) NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSubAcct] [char](24) NOT NULL,
	[EntAmt] [float] NOT NULL,
	[EntTranType] [char](2) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[GLLineId] [smallint] NOT NULL,
	[GLRefNbr] [char](20) NOT NULL,
	[LineID] [smallint] NOT NULL,
	[LTDDepr] [char](1) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[ModuleID] [char](2) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectId] [char](30) NOT NULL,
	[RealPerPost] [char](6) NOT NULL,
	[RealTranDate] [smalldatetime] NOT NULL,
	[TaskId] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](60) NOT NULL,
	[TranType] [char](2) NOT NULL,
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
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0.00)) FOR [Amt]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [BaseCuryID]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [BookSeq]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [CrSubAcct]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0.00)) FOR [CuryAmt]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [CuryID]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0.00)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [DispTran]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [DrSubAcct]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0.00)) FOR [EntAmt]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [EntTranType]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0)) FOR [GLLineId]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [GLRefNbr]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [LTDDepr]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [ModuleID]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [ProjectId]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [RealPerPost]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [RealTranDate]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [TaskId]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [TranDescr]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [TranType]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFATran_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
