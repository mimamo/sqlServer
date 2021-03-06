USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[INArchTran]    Script Date: 12/21/2015 14:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[INArchTran](
	[Acct] [char](10) NOT NULL,
	[AcctDist] [smallint] NOT NULL,
	[ARDocType] [char](2) NOT NULL,
	[ARLineID] [int] NOT NULL,
	[ARLineRef] [char](5) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIEffDate] [smalldatetime] NOT NULL,
	[BMIEstimatedCost] [float] NOT NULL,
	[BMIExtCost] [float] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[BMIRtTp] [char](6) NOT NULL,
	[BMITranAmt] [float] NOT NULL,
	[BMIUnitPrice] [float] NOT NULL,
	[CmmnPct] [float] NOT NULL,
	[CnvFact] [float] NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](24) NOT NULL,
	[CostType] [char](8) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[EstimatedCost] [float] NOT NULL,
	[Excpt] [smallint] NOT NULL,
	[ExtCost] [float] NOT NULL,
	[ExtRefNbr] [char](15) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[FlatRateLineNbr] [smallint] NOT NULL,
	[ID] [char](15) NOT NULL,
	[InsuffQty] [smallint] NOT NULL,
	[InvtAcct] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[InvtMult] [smallint] NOT NULL,
	[InvtSub] [char](24) NOT NULL,
	[IRProcessed] [smallint] NOT NULL,
	[JrnlType] [char](3) NOT NULL,
	[KitID] [char](30) NOT NULL,
	[KitStdQty] [float] NOT NULL,
	[LayerType] [char](1) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigBatNbr] [char](10) NOT NULL,
	[OrigJrnlType] [char](3) NOT NULL,
	[OrigLineRef] [char](5) NOT NULL,
	[OrigRefNbr] [char](10) NOT NULL,
	[OvrhdAmt] [float] NOT NULL,
	[OvrhdFlag] [smallint] NOT NULL,
	[PC_Flag] [char](1) NOT NULL,
	[PC_ID] [char](20) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PostingOption] [smallint] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[QtyUnCosted] [float] NOT NULL,
	[RcptDate] [smalldatetime] NOT NULL,
	[RcptNbr] [char](15) NOT NULL,
	[ReasonCd] [char](6) NOT NULL,
	[RecordID] [int] NOT NULL,
	[RefNbr] [char](15) NOT NULL,
	[Retired] [smallint] NOT NULL,
	[Rlsed] [smallint] NOT NULL,
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
	[ShipperCpnyID] [char](10) NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[ShipperLineRef] [char](5) NOT NULL,
	[ShortQty] [float] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[StdTotalQty] [float] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[SvcContractID] [char](10) NOT NULL,
	[SvcLineNbr] [smallint] NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[ToSiteID] [char](10) NOT NULL,
	[ToWhseLoc] [char](10) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[TranType] [char](2) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[UnitDesc] [char](6) NOT NULL,
	[UnitMultDiv] [char](1) NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UseTranCost] [smallint] NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_AcctDist]  DEFAULT ((0)) FOR [AcctDist]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ARDocType]  DEFAULT (' ') FOR [ARDocType]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ARLineID]  DEFAULT ((0)) FOR [ARLineID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ARLineRef]  DEFAULT (' ') FOR [ARLineRef]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMICuryID]  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIEffDate]  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIEstimatedCost]  DEFAULT ((0)) FOR [BMIEstimatedCost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIExtCost]  DEFAULT ((0)) FOR [BMIExtCost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIMultDiv]  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIRate]  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIRtTp]  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMITranAmt]  DEFAULT ((0)) FOR [BMITranAmt]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_BMIUnitPrice]  DEFAULT ((0)) FOR [BMIUnitPrice]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_CmmnPct]  DEFAULT ((0)) FOR [CmmnPct]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_COGSAcct]  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_COGSSub]  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_CostType]  DEFAULT (' ') FOR [CostType]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_DrCr]  DEFAULT (' ') FOR [DrCr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_EstimatedCost]  DEFAULT ((0)) FOR [EstimatedCost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Excpt]  DEFAULT ((0)) FOR [Excpt]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ExtCost]  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ExtRefNbr]  DEFAULT (' ') FOR [ExtRefNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_FiscYr]  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_FlatRateLineNbr]  DEFAULT ((0)) FOR [FlatRateLineNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ID]  DEFAULT (' ') FOR [ID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_InsuffQty]  DEFAULT ((0)) FOR [InsuffQty]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_InvtAcct]  DEFAULT (' ') FOR [InvtAcct]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_InvtMult]  DEFAULT ((0)) FOR [InvtMult]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_InvtSub]  DEFAULT (' ') FOR [InvtSub]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_IRProcessed]  DEFAULT ((0)) FOR [IRProcessed]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_JrnlType]  DEFAULT (' ') FOR [JrnlType]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_KitStdQty]  DEFAULT ((0)) FOR [KitStdQty]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LayerType]  DEFAULT (' ') FOR [LayerType]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LotSerCntr]  DEFAULT ((0)) FOR [LotSerCntr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_OrigBatNbr]  DEFAULT (' ') FOR [OrigBatNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_OrigJrnlType]  DEFAULT (' ') FOR [OrigJrnlType]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_OrigLineRef]  DEFAULT (' ') FOR [OrigLineRef]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_OrigRefNbr]  DEFAULT (' ') FOR [OrigRefNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_OvrhdAmt]  DEFAULT ((0)) FOR [OvrhdAmt]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_OvrhdFlag]  DEFAULT ((0)) FOR [OvrhdFlag]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_PC_Flag]  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_PC_ID]  DEFAULT (' ') FOR [PC_ID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_PerEnt]  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_PerPost]  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_PostingOption]  DEFAULT ((0)) FOR [PostingOption]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_QtyUnCosted]  DEFAULT ((0)) FOR [QtyUnCosted]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_RcptDate]  DEFAULT ('01/01/1900') FOR [RcptDate]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_RcptNbr]  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ReasonCd]  DEFAULT (' ') FOR [ReasonCd]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_RecordID]  DEFAULT ((0)) FOR [RecordID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_RefNbr]  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Retired]  DEFAULT ((0)) FOR [Retired]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Rlsed]  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ServiceCallID]  DEFAULT (' ') FOR [ServiceCallID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ShipperCpnyID]  DEFAULT (' ') FOR [ShipperCpnyID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ShipperLineRef]  DEFAULT (' ') FOR [ShipperLineRef]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ShortQty]  DEFAULT ((0)) FOR [ShortQty]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_SlsperID]  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_StdTotalQty]  DEFAULT ((0)) FOR [StdTotalQty]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_Sub]  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_SvcContractID]  DEFAULT (' ') FOR [SvcContractID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_SvcLineNbr]  DEFAULT ((0)) FOR [SvcLineNbr]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ToSiteID]  DEFAULT (' ') FOR [ToSiteID]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_ToWhseLoc]  DEFAULT (' ') FOR [ToWhseLoc]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_TranAmt]  DEFAULT ((0)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_TranDate]  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_TranDesc]  DEFAULT (' ') FOR [TranDesc]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_TranType]  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_UnitDesc]  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_UnitPrice]  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_UseTranCost]  DEFAULT ((0)) FOR [UseTranCost]
GO
ALTER TABLE [dbo].[INArchTran] ADD  CONSTRAINT [DF_INArchTran_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
