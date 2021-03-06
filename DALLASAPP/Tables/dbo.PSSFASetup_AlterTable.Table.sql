USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSFASetup_AlterTable]    Script Date: 12/21/2015 13:44:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFASetup_AlterTable](
	[AcquireDateOpt] [char](1) NOT NULL,
	[AdvancedMC] [smallint] NOT NULL,
	[AdvCuryAPRec] [smallint] NOT NULL,
	[AssetDatesActive] [smallint] NOT NULL,
	[AssetZeroAssets] [smallint] NOT NULL,
	[AutoAssetId] [smallint] NOT NULL,
	[AutoDeprSched] [smallint] NOT NULL,
	[AutoLocId] [smallint] NOT NULL,
	[AutoPopulate] [smallint] NOT NULL,
	[AutoSubAsDept] [smallint] NOT NULL,
	[AutoSubAsLocId] [smallint] NOT NULL,
	[AutoUpdateFA010] [smallint] NOT NULL,
	[AutoUpdateFA010Opt] [char](1) NOT NULL,
	[BonusDeprLimit] [float] NOT NULL,
	[ClearingAcct] [char](10) NOT NULL,
	[ClearingSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustomLabel00] [char](30) NOT NULL,
	[CustomLabel01] [char](30) NOT NULL,
	[CustomLabel02] [char](30) NOT NULL,
	[CustomLabel03] [char](30) NOT NULL,
	[CustomLabel04] [char](30) NOT NULL,
	[CustomLabel05] [char](30) NOT NULL,
	[CustomLabel06] [char](30) NOT NULL,
	[CustomLabel07] [char](30) NOT NULL,
	[CustomLabel08] [char](30) NOT NULL,
	[CustomLabel09] [char](30) NOT NULL,
	[CustomLabel10] [char](30) NOT NULL,
	[CustomLabel11] [char](30) NOT NULL,
	[CustomLabel12] [char](30) NOT NULL,
	[CustomLabel13] [char](30) NOT NULL,
	[CustomLabel14] [char](30) NOT NULL,
	[CustomLabel15] [char](30) NOT NULL,
	[CustomLabel16] [char](30) NOT NULL,
	[CustomLabel17] [char](30) NOT NULL,
	[CustomLabel18] [char](30) NOT NULL,
	[CustomLabel19] [char](30) NOT NULL,
	[CustomLabel20] [char](30) NOT NULL,
	[CustomLabel21] [char](30) NOT NULL,
	[CustomLabel22] [char](30) NOT NULL,
	[CustomLabel23] [char](30) NOT NULL,
	[CustomLabel24] [char](30) NOT NULL,
	[CustomTabName] [char](30) NOT NULL,
	[DeprFrom] [char](1) NOT NULL,
	[DeprFromDays] [smallint] NOT NULL,
	[DeprFromFirst] [char](1) NOT NULL,
	[DeprPartialMonths] [smallint] NOT NULL,
	[DeprPerNbrs] [smallint] NOT NULL,
	[DeprProjExpSub] [smallint] NOT NULL,
	[DeprRecapAcct] [char](10) NOT NULL,
	[DeprRecapSub] [char](24) NOT NULL,
	[DeptOverride] [smallint] NOT NULL,
	[DfltApprCounty] [char](30) NOT NULL,
	[DfltApprStateId] [char](3) NOT NULL,
	[DfltAPRecCustodian] [char](20) NOT NULL,
	[DfltAPRecDept] [char](24) NOT NULL,
	[DfltAPRecLocId] [char](24) NOT NULL,
	[DfltCalcLTD] [smallint] NOT NULL,
	[DfltDeprBook1] [char](10) NOT NULL,
	[DfltDeprBook2] [char](10) NOT NULL,
	[DfltDeprBook3] [char](10) NOT NULL,
	[DfltDeprMethod1] [char](20) NOT NULL,
	[DfltDeprMethod2] [char](20) NOT NULL,
	[DfltDeprMethod3] [char](20) NOT NULL,
	[FileAttachLoc] [char](200) NOT NULL,
	[GainLossAcct] [char](10) NOT NULL,
	[GainLossSub] [char](24) NOT NULL,
	[ImpairmentAcct] [char](10) NOT NULL,
	[ImpairmentSubAcct] [char](24) NOT NULL,
	[InclProjTask] [smallint] NOT NULL,
	[IntercompTran] [smallint] NOT NULL,
	[LastAssetId] [char](10) NOT NULL,
	[LastBatId] [char](10) NOT NULL,
	[LastBuildNbr] [char](10) NOT NULL,
	[LastClosePerNbr] [char](6) NOT NULL,
	[LastInvoiceBatNbr] [char](10) NOT NULL,
	[LastLocId] [char](10) NOT NULL,
	[LastRefNbr] [char](10) NOT NULL,
	[LastTranBatNbr] [char](10) NOT NULL,
	[LockedDate] [smalldatetime] NOT NULL,
	[LockedPeriod] [char](6) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MessAPRecords] [smallint] NOT NULL,
	[MessDepr] [smallint] NOT NULL,
	[MMDays] [smallint] NOT NULL,
	[MMType] [char](1) NOT NULL,
	[MultCpnyInput] [smallint] NOT NULL,
	[MultGLBatch] [smallint] NOT NULL,
	[NewAssetsLimit] [smallint] NOT NULL,
	[OverrideDateBasis] [smallint] NOT NULL,
	[ParentCpnyId] [char](10) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PORcptVouched] [smallint] NOT NULL,
	[PostAssetToGL] [smallint] NOT NULL,
	[PostProjTaskToGL] [smallint] NOT NULL,
	[ProceedsAcct] [char](10) NOT NULL,
	[ProceedsSub] [char](24) NOT NULL,
	[PullAPCpny] [smallint] NOT NULL,
	[PullCustodianFrom] [char](1) NOT NULL,
	[PullDriverFrom] [char](1) NOT NULL,
	[PullLocationFrom] [char](1) NOT NULL,
	[PullProjectFrom] [char](1) NOT NULL,
	[RelToGLAsset] [smallint] NOT NULL,
	[RelToGLDepr] [smallint] NOT NULL,
	[RelToGLDisp] [smallint] NOT NULL,
	[RelToGLImp] [smallint] NOT NULL,
	[RelToGLTran] [smallint] NOT NULL,
	[RtTpDflt] [char](6) NOT NULL,
	[Sect179Limit] [float] NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[SLCalcMethod] [char](2) NOT NULL,
	[SubSegment] [smallint] NOT NULL,
	[UnlockKey] [char](25) NOT NULL,
	[UpdateGL] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Version] [char](20) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [AcquireDateOpt]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AdvancedMC]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AdvCuryAPRec]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AssetDatesActive]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AssetZeroAssets]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoAssetId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoDeprSched]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoLocId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoPopulate]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoSubAsDept]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoSubAsLocId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [AutoUpdateFA010]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [AutoUpdateFA010Opt]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [BonusDeprLimit]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ClearingAcct]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ClearingSub]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel00]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel01]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel02]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel03]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel04]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel05]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel06]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel07]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel08]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel09]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel10]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel11]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel12]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel13]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel14]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel15]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel16]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel17]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel18]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel19]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel20]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel21]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel22]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel23]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomLabel24]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [CustomTabName]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DeprFrom]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [DeprFromDays]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DeprFromFirst]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [DeprPartialMonths]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [DeprPerNbrs]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [DeprProjExpSub]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DeprRecapAcct]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DeprRecapSub]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [DeptOverride]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltApprCounty]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltApprStateId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltAPRecCustodian]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltAPRecDept]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltAPRecLocId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [DfltCalcLTD]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltDeprBook1]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltDeprBook2]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltDeprBook3]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltDeprMethod1]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltDeprMethod2]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [DfltDeprMethod3]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [FileAttachLoc]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [GainLossAcct]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [GainLossSub]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ImpairmentAcct]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ImpairmentSubAcct]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [InclProjTask]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [IntercompTran]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastAssetId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastBatId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastBuildNbr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastClosePerNbr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastInvoiceBatNbr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastLocId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LastTranBatNbr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LockedDate]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LockedPeriod]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [MessAPRecords]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [MessDepr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [MMDays]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [MMType]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [MultCpnyInput]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [MultGLBatch]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [NewAssetsLimit]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [OverrideDateBasis]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ParentCpnyId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [PerNbr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [PORcptVouched]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [PostAssetToGL]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [PostProjTaskToGL]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ProceedsAcct]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [ProceedsSub]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [PullAPCpny]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [PullCustodianFrom]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [PullDriverFrom]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [PullLocationFrom]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [PullProjectFrom]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [RelToGLAsset]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [RelToGLDepr]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [RelToGLDisp]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [RelToGLImp]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [RelToGLTran]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [RtTpDflt]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [Sect179Limit]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [SetupId]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [SLCalcMethod]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [SubSegment]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [UnlockKey]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0)) FOR [UpdateGL]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFASetup_AlterTable] ADD  DEFAULT ('') FOR [Version]
GO
