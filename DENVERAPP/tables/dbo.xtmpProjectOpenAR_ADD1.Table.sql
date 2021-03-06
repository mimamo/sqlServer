USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xtmpProjectOpenAR_ADD1]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpProjectOpenAR_ADD1](
	[Client] [varchar](255) NULL,
	[Product] [varchar](255) NULL,
	[JobNbr] [varchar](255) NULL,
	[CodeType] [varchar](255) NULL,
	[ClientInvoice] [varchar](255) NULL,
	[TranDate] [datetime] NULL,
	[JobAmt] [float] NULL,
	[InvoiceAmt] [float] NULL,
	[InvoicePmt] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
