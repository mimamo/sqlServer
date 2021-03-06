USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[smConMisc]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smConMisc](
	[Acct] [char](10) NOT NULL,
	[ARBatnbr] [char](10) NOT NULL,
	[ARRefnbr] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BranchID] [char](10) NOT NULL,
	[ContractID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[ExtPrice] [float] NOT NULL,
	[InvBatNbr] [char](10) NOT NULL,
	[InvoiceLineID] [smallint] NOT NULL,
	[InvoiceNbr] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[Price] [float] NOT NULL,
	[ProcessDate] [smalldatetime] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[Taxable] [char](1) NOT NULL,
	[TaxAmt00] [float] NOT NULL,
	[TaxAmt01] [float] NOT NULL,
	[TaxAmt02] [float] NOT NULL,
	[TaxAmt03] [float] NOT NULL,
	[Taxid00] [char](10) NOT NULL,
	[Taxid01] [char](10) NOT NULL,
	[Taxid02] [char](10) NOT NULL,
	[Taxid03] [char](10) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TxblAmt00] [float] NOT NULL,
	[TxblAmt01] [float] NOT NULL,
	[TxblAmt02] [float] NOT NULL,
	[TxblAmt03] [float] NOT NULL,
	[Unit] [char](6) NOT NULL,
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
