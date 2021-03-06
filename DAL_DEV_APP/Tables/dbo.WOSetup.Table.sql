USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[WOSetup]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOSetup](
	[BackFlush] [char](1) NOT NULL,
	[BuildToTypeDefault] [char](3) NOT NULL,
	[CloseLateChrgAcct] [char](16) NOT NULL,
	[CloseShort] [char](1) NOT NULL,
	[CloseUnapplied] [char](1) NOT NULL,
	[CloseUnissued] [char](1) NOT NULL,
	[COGSNonInv_GLAcct] [char](10) NOT NULL,
	[COGSNonInv_GLSUb] [char](24) NOT NULL,
	[COGSNonInvOverRide] [char](1) NOT NULL,
	[CompAllocMethod] [char](4) NOT NULL,
	[CompChkReleased] [char](1) NOT NULL,
	[CompCMDefault] [char](1) NOT NULL,
	[CompCMDisable] [char](1) NOT NULL,
	[CompGridAllowChgs] [char](1) NOT NULL,
	[CompMapping] [char](1) NOT NULL,
	[CompScrapXferOut] [char](1) NOT NULL,
	[CompSubAssyVarAcct] [char](16) NOT NULL,
	[CompVarTiming] [char](1) NOT NULL,
	[CompXferAllocFlag] [char](1) NOT NULL,
	[CompZeroCost] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeleteMonths] [smallint] NOT NULL,
	[DfltScheduleMaterial] [char](1) NOT NULL,
	[DfltScheduling] [char](1) NOT NULL,
	[DirectLaborAC] [char](16) NOT NULL,
	[DirectMtlAC] [char](16) NOT NULL,
	[DirectOtherAC] [char](16) NOT NULL,
	[GLEntriesTrnsfr] [char](1) NOT NULL,
	[Init] [char](1) NOT NULL,
	[Labor_Acct] [char](16) NOT NULL,
	[LaborBdgUpdate] [char](1) NOT NULL,
	[LaborBdgUpdPrj] [char](1) NOT NULL,
	[LateChrg_GLAcct] [char](10) NOT NULL,
	[LateChrg_GLSub] [char](24) NOT NULL,
	[LateChrgOverRide] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Material_Acct] [char](16) NOT NULL,
	[MaterialBdgUpdate] [char](1) NOT NULL,
	[MaterialBdgUpdPrj] [char](1) NOT NULL,
	[Mfg_Task] [char](32) NOT NULL,
	[MfgGLSub] [char](24) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OvhLaborFixedAC] [char](16) NOT NULL,
	[OvhLaborVarAC] [char](16) NOT NULL,
	[OvhMachFixedAC] [char](16) NOT NULL,
	[OvhMachVarAC] [char](16) NOT NULL,
	[OvhMtlFixedAC] [char](16) NOT NULL,
	[OvhMtlVarAC] [char](16) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PerNbrINDefault] [char](1) NOT NULL,
	[PrjWoGLIMDflt] [char](1) NOT NULL,
	[PrjWoUpdTaskStatus] [char](1) NOT NULL,
	[ProdFri] [char](1) NOT NULL,
	[ProdMon] [char](1) NOT NULL,
	[ProdSat] [char](1) NOT NULL,
	[ProdSun] [char](1) NOT NULL,
	[ProdThu] [char](1) NOT NULL,
	[ProdTue] [char](1) NOT NULL,
	[ProdWed] [char](1) NOT NULL,
	[RateTableID] [char](4) NOT NULL,
	[ReceiptReasonCode] [char](6) NOT NULL,
	[RegAuthorizedUsers] [smallint] NOT NULL,
	[RegCustomerID] [char](10) NOT NULL,
	[RegOptions] [char](15) NOT NULL,
	[RegPlatform] [char](1) NOT NULL,
	[RegUnlockKey] [char](8) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[ScrapCompInvtID] [char](30) NOT NULL,
	[ScrapProdInvtID] [char](30) NOT NULL,
	[SetupID] [char](2) NOT NULL,
	[StdCostVar_GLAcct] [char](10) NOT NULL,
	[StdCostVar_GLSub] [char](24) NOT NULL,
	[TransferAlloc] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[VarianceTiming] [char](1) NOT NULL,
	[WOPendingProject] [char](16) NOT NULL,
	[WORequestRefresh] [smallint] NOT NULL,
	[WOTypeDefault] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_BackFlush]  DEFAULT (' ') FOR [BackFlush]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_BuildToTypeDefault]  DEFAULT (' ') FOR [BuildToTypeDefault]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CloseLateChrgAcct]  DEFAULT (' ') FOR [CloseLateChrgAcct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CloseShort]  DEFAULT (' ') FOR [CloseShort]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CloseUnapplied]  DEFAULT (' ') FOR [CloseUnapplied]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CloseUnissued]  DEFAULT (' ') FOR [CloseUnissued]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_COGSNonInv_GLAcct]  DEFAULT (' ') FOR [COGSNonInv_GLAcct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_COGSNonInv_GLSUb]  DEFAULT (' ') FOR [COGSNonInv_GLSUb]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_COGSNonInvOverRide]  DEFAULT (' ') FOR [COGSNonInvOverRide]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompAllocMethod]  DEFAULT (' ') FOR [CompAllocMethod]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompChkReleased]  DEFAULT (' ') FOR [CompChkReleased]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompCMDefault]  DEFAULT (' ') FOR [CompCMDefault]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompCMDisable]  DEFAULT (' ') FOR [CompCMDisable]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompGridAllowChgs]  DEFAULT (' ') FOR [CompGridAllowChgs]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompMapping]  DEFAULT (' ') FOR [CompMapping]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompScrapXferOut]  DEFAULT (' ') FOR [CompScrapXferOut]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompSubAssyVarAcct]  DEFAULT (' ') FOR [CompSubAssyVarAcct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompVarTiming]  DEFAULT (' ') FOR [CompVarTiming]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompXferAllocFlag]  DEFAULT (' ') FOR [CompXferAllocFlag]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_CompZeroCost]  DEFAULT (' ') FOR [CompZeroCost]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Crtd_Time]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_DeleteMonths]  DEFAULT ((0)) FOR [DeleteMonths]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_DfltScheduleMaterial]  DEFAULT (' ') FOR [DfltScheduleMaterial]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_DfltScheduling]  DEFAULT (' ') FOR [DfltScheduling]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_DirectLaborAC]  DEFAULT (' ') FOR [DirectLaborAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_DirectMtlAC]  DEFAULT (' ') FOR [DirectMtlAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_DirectOtherAC]  DEFAULT (' ') FOR [DirectOtherAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_GLEntriesTrnsfr]  DEFAULT (' ') FOR [GLEntriesTrnsfr]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Init]  DEFAULT (' ') FOR [Init]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Labor_Acct]  DEFAULT (' ') FOR [Labor_Acct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LaborBdgUpdate]  DEFAULT (' ') FOR [LaborBdgUpdate]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LaborBdgUpdPrj]  DEFAULT (' ') FOR [LaborBdgUpdPrj]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LateChrg_GLAcct]  DEFAULT (' ') FOR [LateChrg_GLAcct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LateChrg_GLSub]  DEFAULT (' ') FOR [LateChrg_GLSub]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LateChrgOverRide]  DEFAULT (' ') FOR [LateChrgOverRide]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LUPd_Time]  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Material_Acct]  DEFAULT (' ') FOR [Material_Acct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_MaterialBdgUpdate]  DEFAULT (' ') FOR [MaterialBdgUpdate]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_MaterialBdgUpdPrj]  DEFAULT (' ') FOR [MaterialBdgUpdPrj]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_Mfg_Task]  DEFAULT (' ') FOR [Mfg_Task]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_MfgGLSub]  DEFAULT (' ') FOR [MfgGLSub]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_OvhLaborFixedAC]  DEFAULT (' ') FOR [OvhLaborFixedAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_OvhLaborVarAC]  DEFAULT (' ') FOR [OvhLaborVarAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_OvhMachFixedAC]  DEFAULT (' ') FOR [OvhMachFixedAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_OvhMachVarAC]  DEFAULT (' ') FOR [OvhMachVarAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_OvhMtlFixedAC]  DEFAULT (' ') FOR [OvhMtlFixedAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_OvhMtlVarAC]  DEFAULT (' ') FOR [OvhMtlVarAC]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_PerNbr]  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_PerNbrINDefault]  DEFAULT (' ') FOR [PerNbrINDefault]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_PrjWoGLIMDflt]  DEFAULT (' ') FOR [PrjWoGLIMDflt]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_PrjWoUpdTaskStatus]  DEFAULT (' ') FOR [PrjWoUpdTaskStatus]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdFri]  DEFAULT (' ') FOR [ProdFri]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdMon]  DEFAULT (' ') FOR [ProdMon]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdSat]  DEFAULT (' ') FOR [ProdSat]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdSun]  DEFAULT (' ') FOR [ProdSun]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdThu]  DEFAULT (' ') FOR [ProdThu]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdTue]  DEFAULT (' ') FOR [ProdTue]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ProdWed]  DEFAULT (' ') FOR [ProdWed]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_RateTableID]  DEFAULT (' ') FOR [RateTableID]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ReceiptReasonCode]  DEFAULT (' ') FOR [ReceiptReasonCode]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_RegAuthorizedUsers]  DEFAULT ((0)) FOR [RegAuthorizedUsers]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_RegCustomerID]  DEFAULT (' ') FOR [RegCustomerID]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_RegOptions]  DEFAULT (' ') FOR [RegOptions]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_RegPlatform]  DEFAULT (' ') FOR [RegPlatform]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_RegUnlockKey]  DEFAULT (' ') FOR [RegUnlockKey]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ScrapCompInvtID]  DEFAULT (' ') FOR [ScrapCompInvtID]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_ScrapProdInvtID]  DEFAULT (' ') FOR [ScrapProdInvtID]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_SetupID]  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_StdCostVar_GLAcct]  DEFAULT (' ') FOR [StdCostVar_GLAcct]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_StdCostVar_GLSub]  DEFAULT (' ') FOR [StdCostVar_GLSub]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_TransferAlloc]  DEFAULT (' ') FOR [TransferAlloc]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User10]  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_User9]  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_VarianceTiming]  DEFAULT (' ') FOR [VarianceTiming]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_WOPendingProject]  DEFAULT (' ') FOR [WOPendingProject]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_WORequestRefresh]  DEFAULT ((0)) FOR [WORequestRefresh]
GO
ALTER TABLE [dbo].[WOSetup] ADD  CONSTRAINT [DF_WOSetup_WOTypeDefault]  DEFAULT (' ') FOR [WOTypeDefault]
GO
