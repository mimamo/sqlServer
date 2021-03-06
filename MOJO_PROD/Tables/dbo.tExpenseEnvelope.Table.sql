USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tExpenseEnvelope]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tExpenseEnvelope](
	[ExpenseEnvelopeKey] [int] IDENTITY(1,1) NOT NULL,
	[UserKey] [int] NOT NULL,
	[CompanyKey] [int] NULL,
	[EnvelopeNumber] [varchar](100) NOT NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[Status] [smallint] NULL,
	[Paid] [tinyint] NOT NULL,
	[VoucherKey] [int] NOT NULL,
	[DateCreated] [smalldatetime] NULL,
	[DateSubmitted] [smalldatetime] NULL,
	[DateApproved] [smalldatetime] NULL,
	[ApprovalComments] [varchar](300) NULL,
	[Downloaded] [tinyint] NULL,
	[Comments] [varchar](4000) NULL,
	[VendorKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[SalesTaxAmount] [money] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
 CONSTRAINT [tExpenseEnvelope_PK] PRIMARY KEY CLUSTERED 
(
	[ExpenseEnvelopeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tExpenseEnvelope] ADD  CONSTRAINT [DF_tExpenseEnvelope_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tExpenseEnvelope] ADD  CONSTRAINT [DF_tExpenseEnvelope_Paid]  DEFAULT ((0)) FOR [Paid]
GO
ALTER TABLE [dbo].[tExpenseEnvelope] ADD  CONSTRAINT [DF_tExpenseEnvelope_VoucherKey]  DEFAULT ((0)) FOR [VoucherKey]
GO
ALTER TABLE [dbo].[tExpenseEnvelope] ADD  CONSTRAINT [DF_tExpenseEnvelope_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tExpenseEnvelope] ADD  CONSTRAINT [DF_tExpenseEnvelope_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
