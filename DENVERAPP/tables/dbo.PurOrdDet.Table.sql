USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO


/*******************************************************************************************************
*   DENVERAPP.dbo.PurOrdDet 
*
*   Creator:     
*   Date:         
*   
*
*   Notes:      select top 100 * from denverapp.dbo.PurOrdDet    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/29/2016	Adding some new indexes, dropping some unused ones.
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'PurOrdDet') < 1

CREATE TABLE [dbo].[PurOrdDet](
	[AddlCostPct] [float] NOT NULL,
	[AllocCntr] [smallint] NOT NULL,
	[AlternateID] [char](30) NOT NULL,
	[AltIDType] [char](1) NOT NULL,
	[BlktLineID] [int] NOT NULL,
	[BlktLineRef] [char](5) NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[CostReceived] [float] NOT NULL,
	[CostReturned] [float] NOT NULL,
	[CostVouched] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCostReceived] [float] NOT NULL,
	[CuryCostReturned] [float] NOT NULL,
	[CuryCostVouched] [float] NOT NULL,
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
	[ExtCost] [float] NOT NULL,
	[ExtWeight] [float] NOT NULL,
	[FlatRateLineNbr] [smallint] NOT NULL,
	[InclForecastUsageClc] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[IRIncLeadTime] [smallint] NOT NULL,
	[KitUnExpld] [smallint] NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenLine] [smallint] NOT NULL,
	[OrigPOLine] [smallint] NOT NULL,
	[PC_Flag] [char](1) NOT NULL,
	[PC_ID] [char](20) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[POType] [char](2) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[PromDate] [smalldatetime] NOT NULL,
	[PurAcct] [char](10) NOT NULL,
	[PurchaseType] [char](2) NOT NULL,
	[PurchUnit] [char](6) NOT NULL,
	[PurSub] [char](24) NOT NULL,
	[QtyOrd] [float] NOT NULL,
	[QtyRcvd] [float] NOT NULL,
	[QtyReturned] [float] NOT NULL,
	[QtyVouched] [float] NOT NULL,
	[RcptPctAct] [char](1) NOT NULL,
	[RcptPctMax] [float] NOT NULL,
	[RcptPctMin] [float] NOT NULL,
	[RcptStage] [char](1) NOT NULL,
	[ReasonCd] [char](6) NOT NULL,
	[ReqdDate] [smalldatetime] NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
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
	[ShelfLife] [smallint] NOT NULL,
	[ShipAddr1] [char](60) NOT NULL,
	[ShipAddr2] [char](60) NOT NULL,
	[ShipAddrID] [char](10) NOT NULL,
	[ShipCity] [char](30) NOT NULL,
	[ShipCountry] [char](3) NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipState] [char](3) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SOLineRef] [char](5) NOT NULL,
	[SOOrdNbr] [char](15) NOT NULL,
	[SOSchedRef] [char](5) NOT NULL,
	[StepNbr] [smallint] NOT NULL,
	[SvcContractID] [char](10) NOT NULL,
	[SvcLineNbr] [smallint] NOT NULL,
	[TaskID] [char](32) NOT NULL,
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
	[TaxIdDflt] [char](10) NOT NULL,
	[TranDesc] [char](60) NOT NULL,
	[TxblAmt00] [float] NOT NULL,
	[TxblAmt01] [float] NOT NULL,
	[TxblAmt02] [float] NOT NULL,
	[TxblAmt03] [float] NOT NULL,
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
	[VouchStage] [char](1) NOT NULL,
	[WOBOMSeq] [smallint] NOT NULL,
	[WOCostType] [char](2) NOT NULL,
	[WONbr] [char](10) NOT NULL,
	[WOStepNbr] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


---------------------------------------------
-- modifications
---------------------------------------------
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') AND name = N'IX1_PurOrdDet95B5F')
    DROP INDEX IX1_PurOrdDet95B5F ON [dbo].[PurOrdDet]
go  
  
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') AND name = N'purorddet_stran')
    DROP INDEX purorddet_stran ON [dbo].[PurOrdDet]
go  

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') AND name = N'PurOrdDet1')
    DROP INDEX PurOrdDet1 ON [dbo].[PurOrdDet]
go  
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') AND name = N'PurOrdDet2')
    DROP INDEX PurOrdDet2 ON [dbo].[PurOrdDet]
go  
    
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') AND name = N'PurOrdDet3')
    DROP INDEX PurOrdDet3 ON [dbo].[PurOrdDet]
go  

if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') 
					and name = 'nci_PurOrdDet_VouchStage')

CREATE NONCLUSTERED INDEX [nci_PurOrdDet_VouchStage] ON [dbo].[PurOrdDet]
     ([VouchStage])
INCLUDE ([PONbr], [ProjectID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
go  

if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[PurOrdDet]') 
					and name = 'nci_PurOrdDet_invtId_OpenLine_SiteId_PuchaseType')
					
CREATE NONCLUSTERED INDEX [nci_PurOrdDet_invtId_OpenLine_SiteId_PuchaseType] ON [dbo].[PurOrdDet]
     ([InvtID], [OpenLine], [SiteID], [PurchaseType])
INCLUDE ([CnvFact], [PONbr], [QtyOrd], [QtyRcvd], [UnitMultDiv]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
go  

 


/*
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_AddlCostPct]  DEFAULT ((0)) FOR [AddlCostPct]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_AllocCntr]  DEFAULT ((0)) FOR [AllocCntr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_AlternateID]  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_AltIDType]  DEFAULT (' ') FOR [AltIDType]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_BlktLineID]  DEFAULT ((0)) FOR [BlktLineID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_BlktLineRef]  DEFAULT (' ') FOR [BlktLineRef]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CostReceived]  DEFAULT ((0)) FOR [CostReceived]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CostReturned]  DEFAULT ((0)) FOR [CostReturned]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CostVouched]  DEFAULT ((0)) FOR [CostVouched]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryCostReceived]  DEFAULT ((0)) FOR [CuryCostReceived]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryCostReturned]  DEFAULT ((0)) FOR [CuryCostReturned]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryCostVouched]  DEFAULT ((0)) FOR [CuryCostVouched]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryExtCost]  DEFAULT ((0)) FOR [CuryExtCost]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTaxAmt00]  DEFAULT ((0)) FOR [CuryTaxAmt00]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTaxAmt01]  DEFAULT ((0)) FOR [CuryTaxAmt01]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTaxAmt02]  DEFAULT ((0)) FOR [CuryTaxAmt02]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTaxAmt03]  DEFAULT ((0)) FOR [CuryTaxAmt03]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTxblAmt00]  DEFAULT ((0)) FOR [CuryTxblAmt00]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTxblAmt01]  DEFAULT ((0)) FOR [CuryTxblAmt01]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTxblAmt02]  DEFAULT ((0)) FOR [CuryTxblAmt02]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryTxblAmt03]  DEFAULT ((0)) FOR [CuryTxblAmt03]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_CuryUnitCost]  DEFAULT ((0)) FOR [CuryUnitCost]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ExtCost]  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ExtWeight]  DEFAULT ((0)) FOR [ExtWeight]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_FlatRateLineNbr]  DEFAULT ((0)) FOR [FlatRateLineNbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_InclForecastUsageClc]  DEFAULT ((0)) FOR [InclForecastUsageClc]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_IRIncLeadTime]  DEFAULT ((0)) FOR [IRIncLeadTime]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_KitUnExpld]  DEFAULT ((0)) FOR [KitUnExpld]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_Labor_Class_Cd]  DEFAULT (' ') FOR [Labor_Class_Cd]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_OpenLine]  DEFAULT ((0)) FOR [OpenLine]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_OrigPOLine]  DEFAULT ((0)) FOR [OrigPOLine]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PC_Flag]  DEFAULT (' ') FOR [PC_Flag]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PC_ID]  DEFAULT (' ') FOR [PC_ID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_POType]  DEFAULT (' ') FOR [POType]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PromDate]  DEFAULT ('01/01/1900') FOR [PromDate]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PurAcct]  DEFAULT (' ') FOR [PurAcct]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PurchaseType]  DEFAULT (' ') FOR [PurchaseType]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PurchUnit]  DEFAULT (' ') FOR [PurchUnit]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_PurSub]  DEFAULT (' ') FOR [PurSub]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_QtyOrd]  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_QtyRcvd]  DEFAULT ((0)) FOR [QtyRcvd]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_QtyReturned]  DEFAULT ((0)) FOR [QtyReturned]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_QtyVouched]  DEFAULT ((0)) FOR [QtyVouched]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_RcptPctAct]  DEFAULT (' ') FOR [RcptPctAct]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_RcptPctMax]  DEFAULT ((0)) FOR [RcptPctMax]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_RcptPctMin]  DEFAULT ((0)) FOR [RcptPctMin]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_RcptStage]  DEFAULT (' ') FOR [RcptStage]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ReasonCd]  DEFAULT (' ') FOR [ReasonCd]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ReqdDate]  DEFAULT ('01/01/1900') FOR [ReqdDate]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ReqNbr]  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ServiceCallID]  DEFAULT (' ') FOR [ServiceCallID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShelfLife]  DEFAULT ((0)) FOR [ShelfLife]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipAddr1]  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipAddr2]  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipAddrID]  DEFAULT (' ') FOR [ShipAddrID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipCity]  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipCountry]  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipName]  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipState]  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipViaID]  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_ShipZip]  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_SOLineRef]  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_SOOrdNbr]  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_SOSchedRef]  DEFAULT (' ') FOR [SOSchedRef]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_StepNbr]  DEFAULT ((0)) FOR [StepNbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_SvcContractID]  DEFAULT (' ') FOR [SvcContractID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_SvcLineNbr]  DEFAULT ((0)) FOR [SvcLineNbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxAmt00]  DEFAULT ((0)) FOR [TaxAmt00]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxAmt01]  DEFAULT ((0)) FOR [TaxAmt01]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxAmt02]  DEFAULT ((0)) FOR [TaxAmt02]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxAmt03]  DEFAULT ((0)) FOR [TaxAmt03]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxCalced]  DEFAULT (' ') FOR [TaxCalced]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxCat]  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxID00]  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxID01]  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxID02]  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxID03]  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TaxIdDflt]  DEFAULT (' ') FOR [TaxIdDflt]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TranDesc]  DEFAULT (' ') FOR [TranDesc]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TxblAmt00]  DEFAULT ((0)) FOR [TxblAmt00]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TxblAmt01]  DEFAULT ((0)) FOR [TxblAmt01]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TxblAmt02]  DEFAULT ((0)) FOR [TxblAmt02]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_TxblAmt03]  DEFAULT ((0)) FOR [TxblAmt03]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_UnitWeight]  DEFAULT ((0)) FOR [UnitWeight]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_VouchStage]  DEFAULT (' ') FOR [VouchStage]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_WOBOMSeq]  DEFAULT ((0)) FOR [WOBOMSeq]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_WOCostType]  DEFAULT (' ') FOR [WOCostType]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[PurOrdDet] ADD  CONSTRAINT [DF_PurOrdDet_WOStepNbr]  DEFAULT ((0)) FOR [WOStepNbr]
GO
*/

