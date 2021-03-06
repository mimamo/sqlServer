USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSAssetDeprBook]    Script Date: 12/21/2015 14:26:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSAssetDeprBook](
	[AccDeprAcct] [char](10) NOT NULL,
	[AccDeprSubAcct] [char](24) NOT NULL,
	[AccumDep] [float] NOT NULL,
	[AddlDeprPerc] [char](1) NOT NULL,
	[Apply179] [smallint] NOT NULL,
	[AssetID] [char](10) NOT NULL,
	[AssetSubID] [char](10) NOT NULL,
	[AutoType] [char](1) NOT NULL,
	[AvgConv] [char](1) NOT NULL,
	[Basis] [float] NOT NULL,
	[BonusDepr] [float] NOT NULL,
	[BonusDeprCd] [char](10) NOT NULL,
	[BonusDeprRate] [float] NOT NULL,
	[BonusDeprTaken] [float] NOT NULL,
	[BonusRecap] [float] NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[BookSeq] [char](10) NOT NULL,
	[BusinessUse] [float] NOT NULL,
	[CatId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrLocId] [char](24) NOT NULL,
	[CuryAccumDep] [float] NOT NULL,
	[CuryBasis] [float] NOT NULL,
	[CuryBonusDepr] [float] NOT NULL,
	[CuryBonusDeprRecap] [float] NOT NULL,
	[CuryBonusDeprTaken] [float] NOT NULL,
	[CuryCost] [float] NOT NULL,
	[CuryCostDisposal] [float] NOT NULL,
	[CuryDeprRecap] [float] NOT NULL,
	[CuryGainLossAmt] [float] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRegDeprTaken] [float] NOT NULL,
	[CuryTax179Depr] [float] NOT NULL,
	[CuryTax179Recap] [float] NOT NULL,
	[CuryTax179Taken] [float] NOT NULL,
	[DeprClass] [char](2) NOT NULL,
	[Depreciate] [char](1) NOT NULL,
	[DepreciateB4Disp] [char](1) NOT NULL,
	[DeprExpAcct] [char](10) NOT NULL,
	[DeprExpSubAcct] [char](24) NOT NULL,
	[DeprFrom] [smalldatetime] NOT NULL,
	[DeprFromPerNbr] [char](6) NOT NULL,
	[DeprMethod] [char](20) NOT NULL,
	[DeprRecap] [float] NOT NULL,
	[DispGainLossAcct] [char](10) NOT NULL,
	[DispGainLossSub] [char](24) NOT NULL,
	[GainLossAmt] [float] NOT NULL,
	[ImpairmentAcct] [char](10) NOT NULL,
	[ImpairmentSubAcct] [char](24) NOT NULL,
	[LastDeprDate] [smalldatetime] NOT NULL,
	[LastDeprPerNbr] [char](6) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MMDays] [smallint] NOT NULL,
	[MMType] [char](1) NOT NULL,
	[OverrideAccumDep] [float] NOT NULL,
	[OverrideAcqDate] [smalldatetime] NOT NULL,
	[OverrideBasis] [float] NOT NULL,
	[OverrideBonusDepr] [float] NOT NULL,
	[OverrideBonusDepRate] [float] NOT NULL,
	[OverrideBonusDepTkn] [float] NOT NULL,
	[OverrideBonusRecap] [float] NOT NULL,
	[OverrideCost] [float] NOT NULL,
	[OverrideDeprFrom] [smalldatetime] NOT NULL,
	[OverrideDeprRecap] [float] NOT NULL,
	[OverrideTax179] [smallint] NOT NULL,
	[OverrideTax179Depr] [float] NOT NULL,
	[OverrideTax179Recap] [float] NOT NULL,
	[OverrideTax179Taken] [float] NOT NULL,
	[Qty] [float] NOT NULL,
	[RegDeprTaken] [float] NOT NULL,
	[SalvageValue] [float] NOT NULL,
	[Sect] [char](6) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StatusB4Disp] [char](1) NOT NULL,
	[Tax179] [smallint] NOT NULL,
	[Tax179Depr] [float] NOT NULL,
	[Tax179Recap] [float] NOT NULL,
	[Tax179Taken] [float] NOT NULL,
	[TaxConvMethod] [char](10) NOT NULL,
	[TaxMethod] [char](6) NOT NULL,
	[UsefulLife] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VehicleType] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AccDeprAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AccDeprSubAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [AccumDep]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AddlDeprPerc]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0)) FOR [Apply179]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AssetID]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AssetSubID]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AutoType]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [AvgConv]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [Basis]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [BonusDepr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [BonusDeprCd]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [BonusDeprRate]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [BonusDeprTaken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [BonusRecap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [BookSeq]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [BusinessUse]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [CatId]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [ClassId]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [CurrLocId]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryAccumDep]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryBasis]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryBonusDepr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryBonusDeprRecap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryBonusDeprTaken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryCost]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryCostDisposal]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryDeprRecap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryGainLossAmt]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryRegDeprTaken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryTax179Depr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryTax179Recap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [CuryTax179Taken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DeprClass]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [Depreciate]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DepreciateB4Disp]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DeprExpAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DeprExpSubAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DeprFromPerNbr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [DeprRecap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DispGainLossAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [DispGainLossSub]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [GainLossAmt]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [ImpairmentAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [ImpairmentSubAcct]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [LastDeprDate]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [LastDeprPerNbr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0)) FOR [MMDays]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [MMType]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideAccumDep]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [OverrideAcqDate]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideBasis]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideBonusDepr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideBonusDepRate]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideBonusDepTkn]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideBonusRecap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideCost]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [OverrideDeprFrom]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideDeprRecap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0)) FOR [OverrideTax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideTax179Depr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideTax179Recap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [OverrideTax179Taken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [Qty]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [RegDeprTaken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [SalvageValue]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [Sect]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [StatusB4Disp]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0)) FOR [Tax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [Tax179Depr]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [Tax179Recap]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [Tax179Taken]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [TaxConvMethod]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [TaxMethod]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [UsefulLife]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSAssetDeprBook] ADD  DEFAULT ('') FOR [VehicleType]
GO
