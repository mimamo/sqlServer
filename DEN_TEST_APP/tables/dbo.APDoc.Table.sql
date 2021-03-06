USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[APDoc]    Script Date: 12/21/2015 14:09:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[APDoc](
	[Acct] [char](10) NOT NULL,
	[AddlCost] [smallint] NOT NULL,
	[ApplyAmt] [float] NOT NULL,
	[ApplyDate] [smalldatetime] NOT NULL,
	[ApplyRefNbr] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BatSeq] [int] NOT NULL,
	[CashAcct] [char](10) NOT NULL,
	[CashSub] [char](24) NOT NULL,
	[ClearAmt] [float] NOT NULL,
	[ClearDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrentNbr] [smallint] NOT NULL,
	[CuryDiscBal] [float] NOT NULL,
	[CuryDiscTkn] [float] NOT NULL,
	[CuryDocBal] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryOrigDocAmt] [float] NOT NULL,
	[CuryPmtAmt] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTaxTot00] [float] NOT NULL,
	[CuryTaxTot01] [float] NOT NULL,
	[CuryTaxTot02] [float] NOT NULL,
	[CuryTaxTot03] [float] NOT NULL,
	[CuryTxblTot00] [float] NOT NULL,
	[CuryTxblTot01] [float] NOT NULL,
	[CuryTxblTot02] [float] NOT NULL,
	[CuryTxblTot03] [float] NOT NULL,
	[Cycle] [smallint] NOT NULL,
	[DfltDetail] [smallint] NOT NULL,
	[DirectDeposit] [char](1) NOT NULL,
	[DiscBal] [float] NOT NULL,
	[DiscDate] [smalldatetime] NOT NULL,
	[DiscTkn] [float] NOT NULL,
	[Doc1099] [smallint] NOT NULL,
	[DocBal] [float] NOT NULL,
	[DocClass] [char](1) NOT NULL,
	[DocDate] [smalldatetime] NOT NULL,
	[DocDesc] [char](30) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[DueDate] [smalldatetime] NOT NULL,
	[Econfirm] [char](18) NOT NULL,
	[Estatus] [char](1) NOT NULL,
	[InstallNbr] [smallint] NOT NULL,
	[InvcDate] [smalldatetime] NOT NULL,
	[InvcNbr] [char](15) NOT NULL,
	[LCCode] [char](10) NOT NULL,
	[LineCntr] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MasterDocNbr] [char](10) NOT NULL,
	[NbrCycle] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenDoc] [smallint] NOT NULL,
	[OrigDocAmt] [float] NOT NULL,
	[PayDate] [smalldatetime] NOT NULL,
	[PayHoldDesc] [char](30) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PmtAmt] [float] NOT NULL,
	[PmtID] [char](10) NOT NULL,
	[PmtMethod] [char](1) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[PrePay_RefNbr] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Retention] [smallint] NOT NULL,
	[RGOLAmt] [float] NOT NULL,
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
	[Selected] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[Subcontract] [char](16) NOT NULL,
	[TaxCntr00] [smallint] NOT NULL,
	[TaxCntr01] [smallint] NOT NULL,
	[TaxCntr02] [smallint] NOT NULL,
	[TaxCntr03] [smallint] NOT NULL,
	[TaxId00] [char](10) NOT NULL,
	[TaxId01] [char](10) NOT NULL,
	[TaxId02] [char](10) NOT NULL,
	[TaxId03] [char](10) NOT NULL,
	[TaxTot00] [float] NOT NULL,
	[TaxTot01] [float] NOT NULL,
	[TaxTot02] [float] NOT NULL,
	[TaxTot03] [float] NOT NULL,
	[Terms] [char](2) NOT NULL,
	[TxblTot00] [float] NOT NULL,
	[TxblTot01] [float] NOT NULL,
	[TxblTot02] [float] NOT NULL,
	[TxblTot03] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [APDoc0] PRIMARY KEY CLUSTERED 
(
	[Acct] ASC,
	[Sub] ASC,
	[DocType] ASC,
	[RefNbr] ASC,
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_AddlCost]  DEFAULT ((0)) FOR [AddlCost]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_ApplyAmt]  DEFAULT ((0)) FOR [ApplyAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_ApplyDate]  DEFAULT ('01/01/1900') FOR [ApplyDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_ApplyRefNbr]  DEFAULT (' ') FOR [ApplyRefNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_BatSeq]  DEFAULT ((0)) FOR [BatSeq]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CashAcct]  DEFAULT (' ') FOR [CashAcct]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CashSub]  DEFAULT (' ') FOR [CashSub]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_ClearAmt]  DEFAULT ((0)) FOR [ClearAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_ClearDate]  DEFAULT ('01/01/1900') FOR [ClearDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CurrentNbr]  DEFAULT ((0)) FOR [CurrentNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryDiscBal]  DEFAULT ((0)) FOR [CuryDiscBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryDiscTkn]  DEFAULT ((0)) FOR [CuryDiscTkn]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryDocBal]  DEFAULT ((0)) FOR [CuryDocBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryId]  DEFAULT (' ') FOR [CuryId]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryOrigDocAmt]  DEFAULT ((0)) FOR [CuryOrigDocAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryPmtAmt]  DEFAULT ((0)) FOR [CuryPmtAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTaxTot00]  DEFAULT ((0)) FOR [CuryTaxTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTaxTot01]  DEFAULT ((0)) FOR [CuryTaxTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTaxTot02]  DEFAULT ((0)) FOR [CuryTaxTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTaxTot03]  DEFAULT ((0)) FOR [CuryTaxTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTxblTot00]  DEFAULT ((0)) FOR [CuryTxblTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTxblTot01]  DEFAULT ((0)) FOR [CuryTxblTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTxblTot02]  DEFAULT ((0)) FOR [CuryTxblTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_CuryTxblTot03]  DEFAULT ((0)) FOR [CuryTxblTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Cycle]  DEFAULT ((0)) FOR [Cycle]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DfltDetail]  DEFAULT ((0)) FOR [DfltDetail]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DirectDeposit]  DEFAULT (' ') FOR [DirectDeposit]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DiscBal]  DEFAULT ((0)) FOR [DiscBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DiscDate]  DEFAULT ('01/01/1900') FOR [DiscDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DiscTkn]  DEFAULT ((0)) FOR [DiscTkn]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Doc1099]  DEFAULT ((0)) FOR [Doc1099]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DocBal]  DEFAULT ((0)) FOR [DocBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DocClass]  DEFAULT (' ') FOR [DocClass]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DocDate]  DEFAULT ('01/01/1900') FOR [DocDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DocDesc]  DEFAULT (' ') FOR [DocDesc]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DocType]  DEFAULT (' ') FOR [DocType]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_DueDate]  DEFAULT ('01/01/1900') FOR [DueDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Econfirm]  DEFAULT (' ') FOR [Econfirm]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Estatus]  DEFAULT (' ') FOR [Estatus]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_InstallNbr]  DEFAULT ((0)) FOR [InstallNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_InvcDate]  DEFAULT ('01/01/1900') FOR [InvcDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_InvcNbr]  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_LCCode]  DEFAULT (' ') FOR [LCCode]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_LineCntr]  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_MasterDocNbr]  DEFAULT (' ') FOR [MasterDocNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_NbrCycle]  DEFAULT ((0)) FOR [NbrCycle]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_OpenDoc]  DEFAULT ((0)) FOR [OpenDoc]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_OrigDocAmt]  DEFAULT ((0)) FOR [OrigDocAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PayDate]  DEFAULT ('01/01/1900') FOR [PayDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PayHoldDesc]  DEFAULT (' ') FOR [PayHoldDesc]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PerClosed]  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PerEnt]  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PerPost]  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PmtAmt]  DEFAULT ((0)) FOR [PmtAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PmtID]  DEFAULT (' ') FOR [PmtID]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PmtMethod]  DEFAULT (' ') FOR [PmtMethod]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_PrePay_RefNbr]  DEFAULT (' ') FOR [PrePay_RefNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_RefNbr]  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Retention]  DEFAULT ((0)) FOR [Retention]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_RGOLAmt]  DEFAULT ((0)) FOR [RGOLAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Rlsed]  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Sub]  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Subcontract]  DEFAULT (' ') FOR [Subcontract]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxCntr00]  DEFAULT ((0)) FOR [TaxCntr00]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxCntr01]  DEFAULT ((0)) FOR [TaxCntr01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxCntr02]  DEFAULT ((0)) FOR [TaxCntr02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxCntr03]  DEFAULT ((0)) FOR [TaxCntr03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxId00]  DEFAULT (' ') FOR [TaxId00]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxId01]  DEFAULT (' ') FOR [TaxId01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxId02]  DEFAULT (' ') FOR [TaxId02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxId03]  DEFAULT (' ') FOR [TaxId03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxTot00]  DEFAULT ((0)) FOR [TaxTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxTot01]  DEFAULT ((0)) FOR [TaxTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxTot02]  DEFAULT ((0)) FOR [TaxTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TaxTot03]  DEFAULT ((0)) FOR [TaxTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_Terms]  DEFAULT (' ') FOR [Terms]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TxblTot00]  DEFAULT ((0)) FOR [TxblTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TxblTot01]  DEFAULT ((0)) FOR [TxblTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TxblTot02]  DEFAULT ((0)) FOR [TxblTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_TxblTot03]  DEFAULT ((0)) FOR [TxblTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[APDoc] ADD  CONSTRAINT [DF_APDoc_VendId]  DEFAULT (' ') FOR [VendId]
GO
