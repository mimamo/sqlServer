USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSFAAPRec]    Script Date: 12/21/2015 14:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAPRec](
	[AccessNbr] [int] NOT NULL,
	[Acct] [char](10) NOT NULL,
	[AcctCat] [char](16) NOT NULL,
	[AcqDate] [smalldatetime] NOT NULL,
	[APLineId] [int] NOT NULL,
	[APLineNbr] [smallint] NOT NULL,
	[APRefNbr] [char](10) NOT NULL,
	[APTranType] [char](2) NOT NULL,
	[AssetCpnyId] [char](10) NOT NULL,
	[AssetDescr] [char](60) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[AssetTagNo] [char](50) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CuryCost] [float] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[Custodian] [char](20) NOT NULL,
	[DeprFrom] [smalldatetime] NOT NULL,
	[DeprYN] [char](1) NOT NULL,
	[Dept] [char](24) NOT NULL,
	[DeptYN] [char](1) NOT NULL,
	[EmployeeId] [char](10) NOT NULL,
	[ExpAcct] [char](10) NOT NULL,
	[ExpSubAcct] [char](24) NOT NULL,
	[GLTranType] [char](2) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LocId] [char](24) NOT NULL,
	[LotSerNbr] [char](30) NOT NULL,
	[MfgrLotSerNbr] [char](30) NOT NULL,
	[MyModule] [char](2) NOT NULL,
	[NewCuryId] [char](4) NOT NULL,
	[NewCuryRateType] [char](6) NOT NULL,
	[NonFixedAsset] [smallint] NOT NULL,
	[OMOrdNbr] [char](15) NOT NULL,
	[OMRefNbr] [char](15) NOT NULL,
	[OMShipperId] [char](30) NOT NULL,
	[Paid] [char](1) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[POLineRef] [char](10) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[PORcptBatNbr] [char](10) NOT NULL,
	[PORcptLineNbr] [smallint] NOT NULL,
	[PORcptNbr] [char](10) NOT NULL,
	[PORcptVouchStage] [char](1) NOT NULL,
	[ProjectId] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[RealPONbr] [char](10) NOT NULL,
	[RecordId] [int] NOT NULL,
	[SetupYN] [char](1) NOT NULL,
	[SplitQty] [smallint] NOT NULL,
	[SubAcct] [char](24) NOT NULL,
	[TaskId] [char](32) NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[UseCury] [char](1) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [AcctCat]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('01/01/1900') FOR [AcqDate]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [APLineId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [APLineNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [APRefNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [APTranType]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [AssetCpnyId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [AssetTagNo]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0.00)) FOR [CuryCost]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0.00)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [Custodian]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('01/01/1900') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [DeprYN]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [DeptYN]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [EmployeeId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [ExpAcct]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [ExpSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [GLTranType]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [LocId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [MyModule]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [NewCuryId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [NewCuryRateType]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [NonFixedAsset]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [OMOrdNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [OMRefNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [OMShipperId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [Paid]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [POLineRef]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [PONbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [PORcptBatNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [PORcptLineNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [PORcptNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [PORcptVouchStage]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [ProjectId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0.00)) FOR [Qty]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [RealPONbr]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [RecordId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [SetupYN]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0)) FOR [SplitQty]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [SubAcct]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [TaskId]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ((0.00)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [UseCury]
GO
ALTER TABLE [dbo].[PSSFAAPRec] ADD  DEFAULT ('') FOR [VendId]
GO
