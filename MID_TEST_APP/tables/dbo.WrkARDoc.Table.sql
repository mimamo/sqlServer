USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkARDoc]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkARDoc](
	[Acct] [char](10) NULL,
	[ApplAmt] [float] NULL,
	[ApplBatNbr] [char](10) NULL,
	[ApplBatSeq] [int] NULL,
	[BankAcct] [char](10) NULL,
	[BankSub] [char](24) NULL,
	[BatNbr] [char](10) NOT NULL,
	[BatSeq] [int] NULL,
	[ClearDate] [smalldatetime] NULL,
	[CmmnAmt] [float] NULL,
	[CmmnPct] [float] NULL,
	[CpnyID] [char](10) NULL,
	[CurrentNbr] [smallint] NULL,
	[CuryApplAmt] [float] NULL,
	[CuryClearAmt] [float] NULL,
	[CuryCmmnAmt] [float] NULL,
	[CuryDiscApplAmt] [float] NULL,
	[CuryDiscBal] [float] NULL,
	[CuryDocBal] [float] NULL,
	[CuryEffDate] [smalldatetime] NULL,
	[CuryID] [char](4) NULL,
	[CuryMultDiv] [char](1) NULL,
	[CuryOrigDocAmt] [float] NULL,
	[CuryRate] [float] NULL,
	[CuryRateType] [char](6) NULL,
	[CuryStmtBal] [float] NULL,
	[CuryTaxTot00] [float] NULL,
	[CuryTaxTot01] [float] NULL,
	[CuryTaxTot02] [float] NULL,
	[CuryTaxTot03] [float] NULL,
	[CuryTxblTot00] [float] NULL,
	[CuryTxblTot01] [float] NULL,
	[CuryTxblTot02] [float] NULL,
	[CuryTxblTot03] [float] NULL,
	[CustID] [char](15) NOT NULL,
	[CustOrdNbr] [char](15) NULL,
	[Cycle] [smallint] NULL,
	[DiscApplAmt] [float] NULL,
	[DiscBal] [float] NULL,
	[DiscDate] [smalldatetime] NULL,
	[DocBal] [float] NULL,
	[DocClass] [char](1) NULL,
	[DocDate] [smalldatetime] NULL,
	[DocDesc] [char](30) NULL,
	[DocType] [char](2) NOT NULL,
	[DueDate] [smalldatetime] NULL,
	[JobCntr] [smallint] NULL,
	[LineCntr] [int] NULL,
	[NbrCycle] [smallint] NULL,
	[NoteID] [int] NULL,
	[OpenDoc] [smallint] NULL,
	[OrdNbr] [char](10) NULL,
	[OrigDocAmt] [float] NULL,
	[PC_Status] [char](1) NULL,
	[PerClosed] [char](6) NULL,
	[PerEnt] [char](6) NULL,
	[PerPost] [char](6) NULL,
	[ProjectID] [char](16) NULL,
	[RefNbr] [char](10) NOT NULL,
	[RGOLAmt] [float] NULL,
	[RI_ID] [smallint] NOT NULL,
	[Rlsed] [smallint] NULL,
	[ShipmentNbr] [smallint] NULL,
	[SlsPerID] [char](10) NULL,
	[Status] [char](1) NULL,
	[StmtBal] [float] NULL,
	[StmtDate] [smalldatetime] NULL,
	[Sub] [char](24) NULL,
	[TaskID] [char](32) NULL,
	[TaxCntr00] [smallint] NULL,
	[TaxCntr01] [smallint] NULL,
	[TaxCntr02] [smallint] NULL,
	[TaxCntr03] [smallint] NULL,
	[TaxDate] [smalldatetime] NULL,
	[TaxID00] [char](10) NULL,
	[TaxID01] [char](10) NULL,
	[TaxID02] [char](10) NULL,
	[TaxID03] [char](10) NULL,
	[TaxTot00] [float] NULL,
	[TaxTot01] [float] NULL,
	[TaxTot02] [float] NULL,
	[TaxTot03] [float] NULL,
	[Terms] [char](2) NULL,
	[TxblTot00] [float] NULL,
	[TxblTot01] [float] NULL,
	[TxblTot02] [float] NULL,
	[TxblTot03] [float] NULL,
	[User1] [char](30) NULL,
	[User2] [char](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [char](10) NULL,
	[User6] [char](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkARDoc0] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[BatNbr] ASC,
	[CustID] ASC,
	[DocType] ASC,
	[RefNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
