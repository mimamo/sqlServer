USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpProjectOpenAR_Source]    Script Date: 12/21/2015 16:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpProjectOpenAR_Source](
	[Client] [nvarchar](50) NULL,
	[Product] [nvarchar](50) NULL,
	[JobNbr] [nvarchar](50) NULL,
	[CodeType] [nvarchar](50) NULL,
	[ClientInvoice] [nvarchar](50) NULL,
	[TranDate] [nvarchar](50) NULL,
	[JobAmt] [float] NULL,
	[InvoiceAmt] [float] NULL,
	[InvoicePmt] [float] NULL
) ON [PRIMARY]
GO
