USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[Wrk_SalesTax]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk_SalesTax](
	[CpnyID] [char](10) NOT NULL,
	[RecordID] [int] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[TaxID] [char](10) NOT NULL,
	[TaxRate] [decimal](9, 6) NOT NULL,
	[TaxCalcType] [char](1) NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[YrMon] [char](6) NOT NULL,
	[CuryTaxTot] [decimal](28, 3) NOT NULL,
	[CuryTxblTot] [decimal](28, 3) NOT NULL,
	[TaxTot] [decimal](28, 3) NOT NULL,
	[TxblTot] [decimal](28, 3) NOT NULL,
	[GrpTaxID] [char](10) NOT NULL,
	[GrpRate] [decimal](9, 6) NOT NULL,
	[GrpTaxTot] [decimal](28, 3) NOT NULL,
	[GrpCuryTaxTot] [decimal](28, 3) NOT NULL,
	[CustVend] [char](15) NOT NULL,
	[CuryDecPl] [int] NOT NULL,
	[UserAddress] [char](21) NOT NULL,
 CONSTRAINT [Wrk_SalesTax0] PRIMARY KEY CLUSTERED 
(
	[UserAddress] ASC,
	[RecordID] ASC,
	[TaxID] ASC,
	[RefNbr] ASC,
	[GrpTaxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
