USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFAAssets]    Script Date: 12/21/2015 14:05:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAssets](
	[AccDeprAcct] [char](10) NOT NULL,
	[AccDeprSubAcct] [char](24) NOT NULL,
	[AcquireDate] [smalldatetime] NOT NULL,
	[ApprCounty] [char](30) NOT NULL,
	[ApprStateId] [char](3) NOT NULL,
	[AssetAcct] [char](10) NOT NULL,
	[AssetCond] [char](1) NOT NULL,
	[AssetDescr] [char](60) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubAcct] [char](24) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[AssetType] [char](2) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BillArAcct] [char](10) NOT NULL,
	[BillArSubAcct] [char](24) NOT NULL,
	[BillCust] [char](15) NOT NULL,
	[BillRate] [float] NOT NULL,
	[BillSlsAcct] [char](10) NOT NULL,
	[BillSlsSubAcct] [char](24) NOT NULL,
	[CatId] [char](10) NOT NULL,
	[CheckDate] [smalldatetime] NOT NULL,
	[CheckNbr] [char](30) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Closed] [smallint] NOT NULL,
	[Condition] [char](30) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyAssetNo] [char](30) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrBuildNbr] [char](10) NOT NULL,
	[CurrLocId] [char](24) NOT NULL,
	[CuryCost] [float] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CurySaleAmt] [float] NOT NULL,
	[CuryUseMyRate] [smallint] NOT NULL,
	[Custodian] [char](20) NOT NULL,
	[Custom10Char00] [char](10) NOT NULL,
	[Custom10Char01] [char](10) NOT NULL,
	[Custom10Char02] [char](10) NOT NULL,
	[Custom10Char03] [char](10) NOT NULL,
	[Custom10Char04] [char](10) NOT NULL,
	[Custom60Char00] [char](60) NOT NULL,
	[Custom60Char01] [char](60) NOT NULL,
	[Custom60Char02] [char](60) NOT NULL,
	[Custom60Char03] [char](60) NOT NULL,
	[Custom60Char04] [char](60) NOT NULL,
	[CustomDate00] [smalldatetime] NOT NULL,
	[CustomDate01] [smalldatetime] NOT NULL,
	[CustomDate02] [smalldatetime] NOT NULL,
	[CustomDate03] [smalldatetime] NOT NULL,
	[CustomDate04] [smalldatetime] NOT NULL,
	[CustomFloat00] [float] NOT NULL,
	[CustomFloat01] [float] NOT NULL,
	[CustomFloat02] [float] NOT NULL,
	[CustomFloat03] [float] NOT NULL,
	[CustomFloat04] [float] NOT NULL,
	[CustomInteger00] [smallint] NOT NULL,
	[CustomInteger01] [smallint] NOT NULL,
	[CustomInteger02] [smallint] NOT NULL,
	[CustomInteger03] [smallint] NOT NULL,
	[CustomInteger04] [smallint] NOT NULL,
	[DeprExpAcct] [char](10) NOT NULL,
	[DeprExpSubAcct] [char](24) NOT NULL,
	[DeprFrom] [smalldatetime] NOT NULL,
	[DeprFromPerNbr] [char](6) NOT NULL,
	[Dept] [char](24) NOT NULL,
	[DeptOverride] [smallint] NOT NULL,
	[FMV] [float] NOT NULL,
	[FundSource] [char](10) NOT NULL,
	[GLLineId] [smallint] NOT NULL,
	[InvtDate] [smalldatetime] NOT NULL,
	[LastDeprDate] [smalldatetime] NOT NULL,
	[LeasedFromTo] [char](100) NOT NULL,
	[LMSLoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Manufacturer] [char](30) NOT NULL,
	[Model] [char](30) NOT NULL,
	[NonFixedAsset] [smallint] NOT NULL,
	[Note1] [char](60) NOT NULL,
	[Note2] [char](60) NOT NULL,
	[Note3] [char](60) NOT NULL,
	[Note4] [char](60) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProdUnitsToDate] [float] NOT NULL,
	[ProdUnitsTot] [float] NOT NULL,
	[ProjectID] [char](30) NOT NULL,
	[ProprietryFund] [char](1) NOT NULL,
	[Qty] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[RentPerMon] [float] NOT NULL,
	[RetireDate] [smalldatetime] NOT NULL,
	[RetireMethod] [char](10) NOT NULL,
	[SaleAmt] [float] NOT NULL,
	[SerialNo] [char](30) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TangLeased] [char](1) NOT NULL,
	[TangLeaseNo] [char](20) NOT NULL,
	[TangLessorAddy] [char](70) NOT NULL,
	[TangLessorName] [char](30) NOT NULL,
	[TangLineNbr] [smallint] NOT NULL,
	[TangManYear] [char](4) NOT NULL,
	[TangNewCost] [float] NOT NULL,
	[TangPurchOpt] [char](1) NOT NULL,
	[TangRent] [float] NOT NULL,
	[TangTerm] [smallint] NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[Unit] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User11] [float] NOT NULL,
	[User12] [float] NOT NULL,
	[User13] [char](10) NOT NULL,
	[User14] [char](10) NOT NULL,
	[User15] [smalldatetime] NOT NULL,
	[User16] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[VehicleCarNum] [char](10) NOT NULL,
	[VehicleColor] [char](8) NOT NULL,
	[VehicleConfTag] [char](10) NOT NULL,
	[VehicleDecal] [char](10) NOT NULL,
	[VehicleDriver] [char](30) NOT NULL,
	[VehicleMake] [char](10) NOT NULL,
	[VehicleModel] [char](30) NOT NULL,
	[VehicleTag] [char](10) NOT NULL,
	[VehicleTagExp] [char](6) NOT NULL,
	[VehicleTitle] [char](10) NOT NULL,
	[VehicleTurnedIn] [char](6) NOT NULL,
	[VehicleType] [char](15) NOT NULL,
	[VehicleVin] [char](20) NOT NULL,
	[VehicleWeight] [char](7) NOT NULL,
	[VehicleYear] [char](4) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[VendName] [char](60) NOT NULL,
	[VONbr] [char](10) NOT NULL,
	[WarrantyDescr] [char](60) NOT NULL,
	[WarrantyExpires] [smalldatetime] NOT NULL,
	[WarrantyPhone] [char](30) NOT NULL,
	[WarrantyWith] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AccDeprAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AccDeprSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [AcquireDate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [ApprCounty]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [ApprStateId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetCond]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [AssetType]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [BillArAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [BillArSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [BillCust]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [BillRate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [BillSlsAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [BillSlsSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [CheckDate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CheckNbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [Closed]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Condition]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CpnyAssetNo]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CurrBuildNbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CurrLocId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CuryCost]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CurySaleAmt]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [CuryUseMyRate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custodian]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom10Char00]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom10Char01]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom10Char02]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom10Char03]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom10Char04]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom60Char00]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom60Char01]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom60Char02]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom60Char03]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Custom60Char04]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [CustomDate00]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [CustomDate01]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [CustomDate02]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [CustomDate03]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [CustomDate04]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CustomFloat00]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CustomFloat01]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CustomFloat02]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CustomFloat03]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [CustomFloat04]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [CustomInteger00]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [CustomInteger01]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [CustomInteger02]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [CustomInteger03]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [CustomInteger04]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [DeprExpAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [DeprExpSubAcct]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [DeprFromPerNbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [DeptOverride]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [FMV]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [FundSource]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [GLLineId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [InvtDate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [LastDeprDate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [LeasedFromTo]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [LMSLoanNo]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Manufacturer]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Model]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [NonFixedAsset]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Note1]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Note2]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Note3]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Note4]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [PONbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [ProdUnitsToDate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [ProdUnitsTot]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [ProjectID]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [ProprietryFund]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [Qty]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [RentPerMon]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [RetireDate]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [RetireMethod]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [SaleAmt]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [SerialNo]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TangLeased]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TangLeaseNo]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TangLessorAddy]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TangLessorName]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [TangLineNbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TangManYear]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [TangNewCost]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TangPurchOpt]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [TangRent]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0)) FOR [TangTerm]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [TaskID]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [Unit]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [User11]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [User12]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User13]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User14]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [User15]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [User16]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleCarNum]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleColor]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleConfTag]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleDecal]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleDriver]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleMake]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleModel]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleTag]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleTagExp]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleTitle]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleTurnedIn]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleType]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleVin]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleWeight]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VehicleYear]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VendId]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VendName]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [VONbr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [WarrantyDescr]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('01/01/1900') FOR [WarrantyExpires]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [WarrantyPhone]
GO
ALTER TABLE [dbo].[PSSFAAssets] ADD  DEFAULT ('') FOR [WarrantyWith]
GO
