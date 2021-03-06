USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[smWrkInvoice]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkInvoice](
	[Acct] [char](10) NOT NULL,
	[Amount] [float] NOT NULL,
	[ARBatNbr] [char](10) NOT NULL,
	[BillingType] [char](1) NOT NULL,
	[BranchId] [char](10) NOT NULL,
	[CallDetailType] [char](1) NOT NULL,
	[CmmnAmt] [float] NOT NULL,
	[CmmnPct] [float] NOT NULL,
	[ContractID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustPO] [char](30) NOT NULL,
	[DocDate] [smalldatetime] NOT NULL,
	[DocDesc] [char](30) NOT NULL,
	[DocType] [char](1) NOT NULL,
	[DocumentID] [char](10) NOT NULL,
	[Handling] [smallint] NOT NULL,
	[InvBatNbr] [char](10) NOT NULL,
	[InvoiceType] [char](1) NOT NULL,
	[NoteId] [int] NOT NULL,
	[OrigCallID] [char](10) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Refnbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[ShipTOID] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaxAmt00] [float] NOT NULL,
	[TaxAmt01] [float] NOT NULL,
	[TaxAmt02] [float] NOT NULL,
	[TaxAmt03] [float] NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TermID] [char](2) NOT NULL,
	[TxblAmt00] [float] NOT NULL,
	[TxblAmt01] [float] NOT NULL,
	[TxblAmt02] [float] NOT NULL,
	[TxblAmt03] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [smallint] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[WrkOrdNbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
