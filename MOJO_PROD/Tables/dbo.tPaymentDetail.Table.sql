USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPaymentDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPaymentDetail](
	[PaymentDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[PaymentKey] [int] NOT NULL,
	[GLAccountKey] [int] NOT NULL,
	[ClassKey] [int] NULL,
	[VoucherKey] [int] NULL,
	[Description] [varchar](500) NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitAmount] [money] NULL,
	[DiscAmount] [money] NOT NULL,
	[Amount] [money] NOT NULL,
	[Prepay] [tinyint] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[Exclude1099] [money] NULL,
	[SalesTaxKey] [int] NULL,
	[TargetGLCompanyKey] [int] NULL,
 CONSTRAINT [PK_tPaymentDetail] PRIMARY KEY CLUSTERED 
(
	[PaymentDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPaymentDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_tPaymentDetail_tPayment] FOREIGN KEY([PaymentKey])
REFERENCES [dbo].[tPayment] ([PaymentKey])
GO
ALTER TABLE [dbo].[tPaymentDetail] CHECK CONSTRAINT [FK_tPaymentDetail_tPayment]
GO
ALTER TABLE [dbo].[tPaymentDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_tPaymentDetail_tVoucher] FOREIGN KEY([VoucherKey])
REFERENCES [dbo].[tVoucher] ([VoucherKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tPaymentDetail] NOCHECK CONSTRAINT [FK_tPaymentDetail_tVoucher]
GO
ALTER TABLE [dbo].[tPaymentDetail] ADD  CONSTRAINT [DF_tPaymentDetail_Amount]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[tPaymentDetail] ADD  CONSTRAINT [DF_tPaymentDetail_Prepay]  DEFAULT ((0)) FOR [Prepay]
GO
