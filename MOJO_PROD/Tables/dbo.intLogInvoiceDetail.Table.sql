USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[intLogInvoiceDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[intLogInvoiceDetail](
	[LogKey] [int] NOT NULL,
	[InvoiceNumber] [varchar](35) NOT NULL,
	[ProjectNumber] [varchar](50) NULL,
	[SalesAccountNumber] [varchar](100) NOT NULL,
	[TotalLineAmount] [money] NOT NULL,
	[InvoiceDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
