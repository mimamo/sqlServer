USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[APDoc]    Script Date: 12/21/2015 16:12:19 ******/
SET ANSI_NULLS ON
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
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [AddlCost]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [ApplyAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [ApplyDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [ApplyRefNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [BatSeq]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [CashAcct]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [CashSub]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [ClearAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [ClearDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CurrentNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryDiscBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryDiscTkn]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryDocBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [CuryId]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryOrigDocAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryPmtAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTaxTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTaxTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTaxTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTaxTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTxblTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTxblTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTxblTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [CuryTxblTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [Cycle]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [DfltDetail]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [DirectDeposit]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [DiscBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [DiscDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [DiscTkn]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [Doc1099]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [DocBal]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [DocClass]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [DocDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [DocDesc]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [DocType]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [DueDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Econfirm]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Estatus]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [InstallNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [InvcDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [LCCode]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [MasterDocNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [NbrCycle]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [OpenDoc]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [OrigDocAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [PayDate]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PayHoldDesc]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [PmtAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PmtID]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PmtMethod]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [PrePay_RefNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [Retention]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [RGOLAmt]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Subcontract]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxCntr00]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxCntr01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxCntr02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxCntr03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [TaxId00]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [TaxId01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [TaxId02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [TaxId03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TaxTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [Terms]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TxblTot00]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TxblTot01]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TxblTot02]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [TxblTot03]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[APDoc] ADD  DEFAULT (' ') FOR [VendId]
GO
