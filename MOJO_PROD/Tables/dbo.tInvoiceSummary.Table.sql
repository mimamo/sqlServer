USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceSummary]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tInvoiceSummary](
	[InvoiceKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[Amount] [money] NULL,
	[InvoiceLineKey] [int] NULL,
	[SalesTaxAmount] [money] NULL,
	[OfficeKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
