USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceSummaryTitle]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tInvoiceSummaryTitle](
	[InvoiceKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[TitleKey] [int] NULL,
	[Amount] [money] NULL,
	[InvoiceLineKey] [int] NULL,
	[SalesTaxAmount] [money] NULL,
	[OfficeKey] [int] NULL
) ON [PRIMARY]
GO
