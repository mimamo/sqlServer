USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[POTran]    Script Date: 12/21/2015 14:26:36 ******/
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
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [AcctDist]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [AddlCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [AddlCostPct]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [AddlCostVouch]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [AltIDType]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [APLineID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [APLineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [BMIExtCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [BMITranAmt]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [BMIUnitCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [BMIUnitPrice]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [BOMLineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [BOMSequence]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CostVouched]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryAddlCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryAddlCostVouch]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryCostVouched]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryExtCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryTranAmt]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [CuryUnitCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [DrCr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [ExtWeight]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [FlatRateLineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [JrnlType]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [Labor_Class_Cd]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [OrigRcptDate]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [OrigRcptNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [OrigRetRcptNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PC_ID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [POLineID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [POLineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [POLIneRef]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [POOriginal]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [PurchaseType]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [QtyVouched]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [RcptConvFact]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [RcptDate]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [RcptMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [RcptQty]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [RcptUnitDescr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [ReasonCd]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [ServiceCallID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [SOLineID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [StepNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [SvcContractID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [SvcLineNbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [TaxIDDflt]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [TranDesc]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [UnitDescr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [UnitWeight]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [VendId]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [VouchStage]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [WOBomRef]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [WOCostType]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[POTran] ADD  DEFAULT (' ') FOR [WOStepNbr]
GO
