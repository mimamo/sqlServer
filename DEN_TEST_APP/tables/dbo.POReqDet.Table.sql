USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[POReqDet]    Script Date: 12/21/2015 14:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POReqDet](
	[Acct] [char](10) NOT NULL,
	[AddlCostPct] [float] NOT NULL,
	[AlternateID] [char](30) NOT NULL,
	[AltIDType] [char](1) NOT NULL,
	[AppvLevObt] [char](2) NOT NULL,
	[AppvLevReq] [char](2) NOT NULL,
	[Budgeted] [char](1) NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[CatalogInfo] [char](60) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[CommitAmtLeft] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCommitAmtLeft] [float] NOT NULL,
	[CuryExtCost] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTaxAmt00] [float] NOT NULL,
	[CuryTaxAmt01] [float] NOT NULL,
	[CuryTaxAmt02] [float] NOT NULL,
	[CuryTaxAmt03] [float] NOT NULL,
	[CuryTxblAmt00] [float] NOT NULL,
	[CuryTxblAmt01] [float] NOT NULL,
	[CuryTxblAmt02] [float] NOT NULL,
	[CuryTxblAmt03] [float] NOT NULL,
	[CuryUnitCost] [float] NOT NULL,
	[DeletedLine] [smallint] NOT NULL,
	[Dept] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[ExtCost] [float] NOT NULL,
	[ExtWeight] [float] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[ItemLineID] [smallint] NOT NULL,
	[ItemLineRef] [char](5) NOT NULL,
	[ItemReqNbr] [char](10) NOT NULL,
	[KitUnexpID] [smallint] NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LineID] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigPOSeq] [char](1) NOT NULL,
	[PC_Flag] [char](1) NOT NULL,
	[PC_ID] [char](20) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PolicyLevObt] [char](2) NOT NULL,
	[PolicyLevReq] [char](2) NOT NULL,
	[PrefVendorID] [char](15) NOT NULL,
	[Project] [char](16) NOT NULL,
	[PromiseDate] [smalldatetime] NOT NULL,
	[PurchaseType] [char](2) NOT NULL,
	[Qty] [float] NOT NULL,
	[RcptPctAct] [char](1) NOT NULL,
	[RcptPctMax] [float] NOT NULL,
	[RcptPctMin] [float] NOT NULL,
	[ReqCntr] [char](2) NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
	[RequiredDate] [smalldatetime] NOT NULL,
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
	[SeqNbr] [char](4) NOT NULL,
	[ShipFrom] [char](20) NOT NULL,
	[ShipVia] [char](20) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SourceOfRequest] [char](3) NOT NULL,
	[Status] [char](2) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[Task] [char](32) NOT NULL,
	[TaxAmt00] [float] NOT NULL,
	[TaxAmt01] [float] NOT NULL,
	[TaxAmt02] [float] NOT NULL,
	[TaxAmt03] [float] NOT NULL,
	[TaxCalced] [char](1) NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TaxIDDflt] [char](10) NOT NULL,
	[Transfer] [char](1) NOT NULL,
	[TxblAmt00] [float] NOT NULL,
	[TxblAmt01] [float] NOT NULL,
	[TxblAmt02] [float] NOT NULL,
	[TxblAmt03] [float] NOT NULL,
	[Unit] [char](6) NOT NULL,
	[UnitCost] [float] NOT NULL,
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
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_AddlCostPct]  DEFAULT ((0)) FOR [AddlCostPct]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_AlternateID]  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_AltIDType]  DEFAULT (' ') FOR [AltIDType]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_AppvLevObt]  DEFAULT (' ') FOR [AppvLevObt]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_AppvLevReq]  DEFAULT (' ') FOR [AppvLevReq]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Budgeted]  DEFAULT (' ') FOR [Budgeted]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CatalogInfo]  DEFAULT (' ') FOR [CatalogInfo]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CommitAmtLeft]  DEFAULT ((0)) FOR [CommitAmtLeft]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryCommitAmtLeft]  DEFAULT ((0)) FOR [CuryCommitAmtLeft]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryExtCost]  DEFAULT ((0)) FOR [CuryExtCost]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTaxAmt00]  DEFAULT ((0)) FOR [CuryTaxAmt00]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTaxAmt01]  DEFAULT ((0)) FOR [CuryTaxAmt01]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTaxAmt02]  DEFAULT ((0)) FOR [CuryTaxAmt02]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTaxAmt03]  DEFAULT ((0)) FOR [CuryTaxAmt03]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTxblAmt00]  DEFAULT ((0)) FOR [CuryTxblAmt00]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTxblAmt01]  DEFAULT ((0)) FOR [CuryTxblAmt01]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTxblAmt02]  DEFAULT ((0)) FOR [CuryTxblAmt02]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryTxblAmt03]  DEFAULT ((0)) FOR [CuryTxblAmt03]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_CuryUnitCost]  DEFAULT ((0)) FOR [CuryUnitCost]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_DeletedLine]  DEFAULT ((0)) FOR [DeletedLine]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Dept]  DEFAULT (' ') FOR [Dept]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ExtCost]  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ExtWeight]  DEFAULT ((0)) FOR [ExtWeight]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ItemLineID]  DEFAULT ((0)) FOR [ItemLineID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ItemLineRef]  DEFAULT (' ') FOR [ItemLineRef]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ItemReqNbr]  DEFAULT (' ') FOR [ItemReqNbr]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_KitUnexpID]  DEFAULT ((0)) FOR [KitUnexpID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Labor_Class_Cd]  DEFAULT (' ') FOR [Labor_Class_Cd]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_MaterialType]  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_OrigPOSeq]  DEFAULT (' ') FOR [OrigPOSeq]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PC_Flag]  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PC_ID]  DEFAULT (' ') FOR [PC_ID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PolicyLevObt]  DEFAULT (' ') FOR [PolicyLevObt]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PolicyLevReq]  DEFAULT (' ') FOR [PolicyLevReq]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PrefVendorID]  DEFAULT (' ') FOR [PrefVendorID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Project]  DEFAULT (' ') FOR [Project]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PromiseDate]  DEFAULT ('01/01/1900') FOR [PromiseDate]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_PurchaseType]  DEFAULT (' ') FOR [PurchaseType]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_RcptPctAct]  DEFAULT (' ') FOR [RcptPctAct]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_RcptPctMax]  DEFAULT ((0)) FOR [RcptPctMax]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_RcptPctMin]  DEFAULT ((0)) FOR [RcptPctMin]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ReqCntr]  DEFAULT (' ') FOR [ReqCntr]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ReqNbr]  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_RequiredDate]  DEFAULT ('01/01/1900') FOR [RequiredDate]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_SeqNbr]  DEFAULT (' ') FOR [SeqNbr]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ShipFrom]  DEFAULT (' ') FOR [ShipFrom]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_ShipVia]  DEFAULT (' ') FOR [ShipVia]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_SourceOfRequest]  DEFAULT (' ') FOR [SourceOfRequest]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Sub]  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Task]  DEFAULT (' ') FOR [Task]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxAmt00]  DEFAULT ((0)) FOR [TaxAmt00]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxAmt01]  DEFAULT ((0)) FOR [TaxAmt01]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxAmt02]  DEFAULT ((0)) FOR [TaxAmt02]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxAmt03]  DEFAULT ((0)) FOR [TaxAmt03]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxCalced]  DEFAULT (' ') FOR [TaxCalced]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxCat]  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxID00]  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxID01]  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxID02]  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxID03]  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TaxIDDflt]  DEFAULT (' ') FOR [TaxIDDflt]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Transfer]  DEFAULT (' ') FOR [Transfer]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TxblAmt00]  DEFAULT ((0)) FOR [TxblAmt00]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TxblAmt01]  DEFAULT ((0)) FOR [TxblAmt01]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TxblAmt02]  DEFAULT ((0)) FOR [TxblAmt02]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_TxblAmt03]  DEFAULT ((0)) FOR [TxblAmt03]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_Unit]  DEFAULT (' ') FOR [Unit]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_UnitWeight]  DEFAULT ((0)) FOR [UnitWeight]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POReqDet] ADD  CONSTRAINT [DF_POReqDet_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
