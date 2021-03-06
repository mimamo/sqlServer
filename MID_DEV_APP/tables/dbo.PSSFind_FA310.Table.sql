USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFind_FA310]    Script Date: 12/21/2015 14:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFind_FA310](
	[AccDeprAcct] [char](10) NOT NULL,
	[AccDeprSubAcct] [char](24) NOT NULL,
	[AccessNbr] [smallint] NOT NULL,
	[AcquireDate] [smalldatetime] NOT NULL,
	[AssetAcct] [char](10) NOT NULL,
	[AssetDescr] [char](50) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubAcct] [char](24) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[AssetType] [char](2) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[CheckDate] [smalldatetime] NOT NULL,
	[CheckNbr] [char](30) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Condition] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyAssetNo] [char](30) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CrSubAcct] [char](24) NOT NULL,
	[CurrLocId] [char](24) NOT NULL,
	[DeprExpAcct] [char](10) NOT NULL,
	[DeprExpSubAcct] [char](24) NOT NULL,
	[DeprFrom] [smalldatetime] NOT NULL,
	[DeprMethod] [char](20) NOT NULL,
	[Dept] [char](24) NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSubAcct] [char](24) NOT NULL,
	[FundSource] [char](10) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[GLLineId] [smallint] NOT NULL,
	[InvtDate] [smalldatetime] NOT NULL,
	[LastDeprDate] [smalldatetime] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Manufacturer] [char](30) NOT NULL,
	[Model] [char](30) NOT NULL,
	[ModuleID] [char](2) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProprietryFund] [char](1) NOT NULL,
	[RetireDate] [smalldatetime] NOT NULL,
	[RetireMethod] [char](10) NOT NULL,
	[SaleAmt] [float] NOT NULL,
	[SerialNo] [char](20) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](60) NOT NULL,
	[TranType] [char](1) NOT NULL,
	[Unit] [char](10) NOT NULL,
	[VehicleTag] [char](10) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[VendName] [char](30) NOT NULL,
	[WarrantyDescr] [char](60) NOT NULL,
	[WarrantyExpires] [smalldatetime] NOT NULL,
	[WarrantyPhone] [char](30) NOT NULL,
	[WarrantyWith] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AccDeprAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AccDeprSubAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [AcquireDate]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AssetAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AssetSubAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [AssetType]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [CheckDate]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CheckNbr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [Condition]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CpnyAssetNo]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CrSubAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [CurrLocId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [DeprExpAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [DeprExpSubAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [DrSubAcct]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [FundSource]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0)) FOR [GLLineId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [InvtDate]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [LastDeprDate]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [Manufacturer]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [Model]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [ModuleID]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [PONbr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [ProjectID]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [ProprietryFund]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [RetireDate]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [RetireMethod]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0.00)) FOR [SaleAmt]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [SerialNo]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [TaskID]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [TranDescr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [TranType]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [Unit]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [VehicleTag]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [VendId]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [VendName]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [WarrantyDescr]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('01/01/1900') FOR [WarrantyExpires]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [WarrantyPhone]
GO
ALTER TABLE [dbo].[PSSFind_FA310] ADD  DEFAULT ('') FOR [WarrantyWith]
GO
