USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[POTran]    Script Date: 12/21/2015 14:05:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POTran](
	[Acct] [char](10) NOT NULL,
	[AcctDist] [smallint] NOT NULL,
	[AddlCost] [float] NOT NULL,
	[AddlCostPct] [float] NOT NULL,
	[AddlCostVouch] [float] NOT NULL,
	[AlternateID] [char](30) NOT NULL,
	[AltIDType] [char](1) NOT NULL,
	[APLineID] [smallint] NOT NULL,
	[APLineRef] [char](5) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIEffDate] [smalldatetime] NOT NULL,
	[BMIExtCost] [float] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[BMIRtTp] [char](6) NOT NULL,
	[BMITranAmt] [float] NOT NULL,
	[BMIUnitCost] [float] NOT NULL,
	[BMIUnitPrice] [float] NOT NULL,
	[BOMLineRef] [char](5) NOT NULL,
	[BOMSequence] [smallint] NOT NULL,
	[CnvFact] [float] NOT NULL,
	[CostVouched] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAddlCost] [float] NOT NULL,
	[CuryAddlCostVouch] [float] NOT NULL,
	[CuryCostVouched] [float] NOT NULL,
	[CuryExtCost] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[CuryUnitCost] [float] NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[ExtCost] [float] NOT NULL,
	[ExtWeight] [float] NOT NULL,
	[FlatRateLineNbr] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[JrnlType] [char](3) NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigRcptDate] [smalldatetime] NOT NULL,
	[OrigRcptNbr] [char](10) NOT NULL,
	[OrigRetRcptNbr] [char](10) NOT NULL,
	[PC_Flag] [char](1) NOT NULL,
	[PC_ID] [char](20) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[POLineID] [int] NOT NULL,
	[POLineNbr] [smallint] NOT NULL,
	[POLIneRef] [char](5) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[POOriginal] [char](1) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[PurchaseType] [char](2) NOT NULL,
	[Qty] [float] NOT NULL,
	[QtyVouched] [float] NOT NULL,
	[RcptConvFact] [float] NOT NULL,
	[RcptDate] [smalldatetime] NOT NULL,
	[RcptMultDiv] [char](1) NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
	[RcptQty] [float] NOT NULL,
	[RcptUnitDescr] [char](6) NOT NULL,
	[ReasonCd] [char](6) NOT NULL,
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
	[ServiceCallID] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SOLineID] [int] NOT NULL,
	[SOLineRef] [char](5) NOT NULL,
	[SOOrdNbr] [char](15) NOT NULL,
	[SOTypeID] [char](4) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[StepNbr] [smallint] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[SvcContractID] [char](10) NOT NULL,
	[SvcLineNbr] [smallint] NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TaxIDDflt] [char](10) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](60) NOT NULL,
	[TranType] [char](2) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[UnitDescr] [char](6) NOT NULL,
	[UnitMultDiv] [char](1) NOT NULL,
	[UnitWeight] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[VouchStage] [char](1) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[WOBomRef] [char](5) NOT NULL,
	[WOCostType] [char](2) NOT NULL,
	[WONbr] [char](10) NOT NULL,
	[WOStepNbr] [char](5) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_AcctDist]  DEFAULT ((0)) FOR [AcctDist]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_AddlCost]  DEFAULT ((0)) FOR [AddlCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_AddlCostPct]  DEFAULT ((0)) FOR [AddlCostPct]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_AddlCostVouch]  DEFAULT ((0)) FOR [AddlCostVouch]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_AlternateID]  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_AltIDType]  DEFAULT (' ') FOR [AltIDType]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_APLineID]  DEFAULT ((0)) FOR [APLineID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_APLineRef]  DEFAULT (' ') FOR [APLineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMICuryID]  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIEffDate]  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIExtCost]  DEFAULT ((0)) FOR [BMIExtCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIMultDiv]  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIRate]  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIRtTp]  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMITranAmt]  DEFAULT ((0)) FOR [BMITranAmt]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIUnitCost]  DEFAULT ((0)) FOR [BMIUnitCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BMIUnitPrice]  DEFAULT ((0)) FOR [BMIUnitPrice]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BOMLineRef]  DEFAULT (' ') FOR [BOMLineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_BOMSequence]  DEFAULT ((0)) FOR [BOMSequence]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CostVouched]  DEFAULT ((0)) FOR [CostVouched]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryAddlCost]  DEFAULT ((0)) FOR [CuryAddlCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryAddlCostVouch]  DEFAULT ((0)) FOR [CuryAddlCostVouch]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryCostVouched]  DEFAULT ((0)) FOR [CuryCostVouched]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryExtCost]  DEFAULT ((0)) FOR [CuryExtCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryTranAmt]  DEFAULT ((0)) FOR [CuryTranAmt]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_CuryUnitCost]  DEFAULT ((0)) FOR [CuryUnitCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_DrCr]  DEFAULT (' ') FOR [DrCr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_ExtCost]  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_ExtWeight]  DEFAULT ((0)) FOR [ExtWeight]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_FlatRateLineNbr]  DEFAULT ((0)) FOR [FlatRateLineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_JrnlType]  DEFAULT (' ') FOR [JrnlType]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Labor_Class_Cd]  DEFAULT (' ') FOR [Labor_Class_Cd]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_OrigRcptDate]  DEFAULT ('01/01/1900') FOR [OrigRcptDate]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_OrigRcptNbr]  DEFAULT (' ') FOR [OrigRcptNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_OrigRetRcptNbr]  DEFAULT (' ') FOR [OrigRetRcptNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PC_Flag]  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PC_ID]  DEFAULT (' ') FOR [PC_ID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PerEnt]  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PerPost]  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_POLineID]  DEFAULT ((0)) FOR [POLineID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_POLineNbr]  DEFAULT ((0)) FOR [POLineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_POLIneRef]  DEFAULT (' ') FOR [POLIneRef]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_POOriginal]  DEFAULT (' ') FOR [POOriginal]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_PurchaseType]  DEFAULT (' ') FOR [PurchaseType]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_QtyVouched]  DEFAULT ((0)) FOR [QtyVouched]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_RcptConvFact]  DEFAULT ((0)) FOR [RcptConvFact]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_RcptDate]  DEFAULT ('01/01/1900') FOR [RcptDate]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_RcptMultDiv]  DEFAULT (' ') FOR [RcptMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_RcptNbr]  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_RcptQty]  DEFAULT ((0)) FOR [RcptQty]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_RcptUnitDescr]  DEFAULT (' ') FOR [RcptUnitDescr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_ReasonCd]  DEFAULT (' ') FOR [ReasonCd]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_ServiceCallID]  DEFAULT (' ') FOR [ServiceCallID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SOLineID]  DEFAULT ((0)) FOR [SOLineID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SOLineRef]  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SOOrdNbr]  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SOTypeID]  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_StepNbr]  DEFAULT ((0)) FOR [StepNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_Sub]  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SvcContractID]  DEFAULT (' ') FOR [SvcContractID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_SvcLineNbr]  DEFAULT ((0)) FOR [SvcLineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TaxCat]  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TaxIDDflt]  DEFAULT (' ') FOR [TaxIDDflt]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TranAmt]  DEFAULT ((0)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TranDate]  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TranDesc]  DEFAULT (' ') FOR [TranDesc]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_TranType]  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_UnitDescr]  DEFAULT (' ') FOR [UnitDescr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_UnitWeight]  DEFAULT ((0)) FOR [UnitWeight]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_VendId]  DEFAULT (' ') FOR [VendId]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_VouchStage]  DEFAULT (' ') FOR [VouchStage]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_WOBomRef]  DEFAULT (' ') FOR [WOBomRef]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_WOCostType]  DEFAULT (' ') FOR [WOCostType]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[POTran] ADD  CONSTRAINT [DF_POTran_WOStepNbr]  DEFAULT (' ') FOR [WOStepNbr]
GO
