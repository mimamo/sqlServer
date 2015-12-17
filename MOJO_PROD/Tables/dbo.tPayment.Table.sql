USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPayment]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPayment](
	[PaymentKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[CashAccountKey] [int] NOT NULL,
	[ClassKey] [int] NULL,
	[PaymentDate] [smalldatetime] NOT NULL,
	[PostingDate] [smalldatetime] NULL,
	[CheckNumber] [varchar](50) NULL,
	[CheckNumberTemp] [varchar](50) NULL,
	[VendorKey] [int] NOT NULL,
	[PayToName] [varchar](300) NOT NULL,
	[PayToAddress1] [varchar](300) NULL,
	[PayToAddress2] [varchar](300) NULL,
	[PayToAddress3] [varchar](300) NULL,
	[PayToAddress4] [varchar](300) NULL,
	[PayToAddress5] [varchar](300) NULL,
	[Memo] [varchar](500) NULL,
	[PaymentAmount] [money] NOT NULL,
	[Posted] [tinyint] NOT NULL,
	[VoidPaymentKey] [int] NOT NULL,
	[UnappliedPaymentAccountKey] [int] NULL,
	[AddressKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[OpeningTransaction] [tinyint] NULL,
	[RecurringParentKey] [int] NULL,
	[NextCheckNumber] [varchar](50) NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
 CONSTRAINT [PK_tPayment] PRIMARY KEY CLUSTERED 
(
	[PaymentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPayment] ADD  CONSTRAINT [DF_tPayment_PaymentAmount]  DEFAULT ((0)) FOR [PaymentAmount]
GO
ALTER TABLE [dbo].[tPayment] ADD  CONSTRAINT [DF_tPayment_Posted]  DEFAULT ((0)) FOR [Posted]
GO
ALTER TABLE [dbo].[tPayment] ADD  CONSTRAINT [DF_tPayment_Void]  DEFAULT ((0)) FOR [VoidPaymentKey]
GO
ALTER TABLE [dbo].[tPayment] ADD  CONSTRAINT [DF_tPayment_OpeningTransaction]  DEFAULT ((0)) FOR [OpeningTransaction]
GO
ALTER TABLE [dbo].[tPayment] ADD  CONSTRAINT [DF_tPayment_RecurringParentKey]  DEFAULT ((0)) FOR [RecurringParentKey]
GO
ALTER TABLE [dbo].[tPayment] ADD  CONSTRAINT [DF_tPayment_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
