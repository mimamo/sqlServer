USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[xWKMJG_Billing_Exception_tmp]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xWKMJG_Billing_Exception_tmp](
	[EntityKey] [int] NULL,
	[Action] [varchar](50) NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateTransferred] [smalldatetime] NULL,
	[Error] [varchar](50) NULL,
	[TransferStatus] [varchar](50) NULL,
	[InvoiceNumber] [varchar](50) NULL,
	[ProjectNumber] [varchar](50) NULL,
	[FunctionCode] [varchar](50) NULL,
	[Amount] [float] NULL,
	[InvoiceDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
