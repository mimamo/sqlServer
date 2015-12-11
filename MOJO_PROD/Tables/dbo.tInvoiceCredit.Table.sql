USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceCredit]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tInvoiceCredit](
	[InvoiceCreditKey] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceKey] [int] NOT NULL,
	[CreditInvoiceKey] [int] NOT NULL,
	[Description] [varchar](500) NULL,
	[Amount] [money] NOT NULL,
 CONSTRAINT [PK_tInvoiceCredit] PRIMARY KEY CLUSTERED 
(
	[InvoiceCreditKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
