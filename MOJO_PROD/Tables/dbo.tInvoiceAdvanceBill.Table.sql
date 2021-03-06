USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceAdvanceBill]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tInvoiceAdvanceBill](
	[InvoiceAdvanceBillKey] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceKey] [int] NOT NULL,
	[AdvBillInvoiceKey] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[FromAB] [tinyint] NULL,
 CONSTRAINT [PK_tInvoiceAdvanceBill] PRIMARY KEY CLUSTERED 
(
	[InvoiceAdvanceBillKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tInvoiceAdvanceBill] ADD  CONSTRAINT [DF_tInvoiceAdvanceBill_FromAB]  DEFAULT ((0)) FOR [FromAB]
GO
