USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceLine]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tInvoiceLine](
	[InvoiceLineKey] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[LineType] [smallint] NULL,
	[ParentLineKey] [int] NULL,
	[LineSubject] [varchar](100) NOT NULL,
	[LineDescription] [text] NULL,
	[BillFrom] [smallint] NOT NULL,
	[BilledTimeAmount] [money] NULL,
	[BilledExpenseAmount] [money] NULL,
	[Quantity] [decimal](24, 4) NOT NULL,
	[UnitAmount] [money] NOT NULL,
	[TotalAmount] [money] NOT NULL,
	[PostSalesUsingDetail] [tinyint] NOT NULL,
	[SalesAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[DisplayOrder] [int] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[WorkTypeKey] [int] NULL,
	[InvoiceOrder] [int] NULL,
	[LineLevel] [int] NULL,
	[Entity] [varchar](100) NULL,
	[EntityKey] [int] NULL,
	[RetainerKey] [int] NULL,
	[EstimateKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [nvarchar](50) NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[DisplayOption] [smallint] NULL,
	[CampaignSegmentKey] [int] NULL,
	[TargetGLCompanyKey] [int] NULL,
 CONSTRAINT [tInvoiceLine_PK] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tInvoiceLine]  WITH CHECK ADD  CONSTRAINT [tInvoice_tInvoiceLine_FK1] FOREIGN KEY([InvoiceKey])
REFERENCES [dbo].[tInvoice] ([InvoiceKey])
GO
ALTER TABLE [dbo].[tInvoiceLine] CHECK CONSTRAINT [tInvoice_tInvoiceLine_FK1]
GO
ALTER TABLE [dbo].[tInvoiceLine] ADD  CONSTRAINT [DF_tInvoiceLine_BillFrom]  DEFAULT ((1)) FOR [BillFrom]
GO
ALTER TABLE [dbo].[tInvoiceLine] ADD  CONSTRAINT [DF_tInvoiceLine_Quantity]  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[tInvoiceLine] ADD  CONSTRAINT [DF_tInvoiceLine_UnitAmount]  DEFAULT ((0)) FOR [UnitAmount]
GO
ALTER TABLE [dbo].[tInvoiceLine] ADD  CONSTRAINT [DF_tInvoiceLine_TotalAmount]  DEFAULT ((0)) FOR [TotalAmount]
GO
ALTER TABLE [dbo].[tInvoiceLine] ADD  CONSTRAINT [DF_tInvoiceLine_PostSalesUsingDetail]  DEFAULT ((0)) FOR [PostSalesUsingDetail]
GO
