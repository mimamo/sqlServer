USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskExpense]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEstimateTaskExpense](
	[EstimateTaskExpenseKey] [int] IDENTITY(1,1) NOT NULL,
	[EstimateKey] [int] NOT NULL,
	[TaskKey] [int] NULL,
	[ItemKey] [int] NULL,
	[ShortDescription] [varchar](200) NULL,
	[LongDescription] [varchar](1000) NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitCost] [money] NULL,
	[UnitDescription] [varchar](30) NULL,
	[TotalCost] [money] NULL,
	[Billable] [tinyint] NULL,
	[Markup] [decimal](24, 4) NULL,
	[BillableCost] [money] NULL,
	[Taxable] [tinyint] NULL,
	[Quantity2] [decimal](24, 4) NULL,
	[UnitCost2] [money] NULL,
	[UnitDescription2] [varchar](30) NULL,
	[TotalCost2] [money] NULL,
	[Markup2] [decimal](24, 4) NULL,
	[BillableCost2] [money] NULL,
	[Quantity3] [decimal](24, 4) NULL,
	[UnitCost3] [money] NULL,
	[UnitDescription3] [varchar](30) NULL,
	[TotalCost3] [money] NULL,
	[Markup3] [decimal](24, 4) NULL,
	[BillableCost3] [money] NULL,
	[Quantity4] [decimal](24, 4) NULL,
	[UnitCost4] [money] NULL,
	[UnitDescription4] [varchar](30) NULL,
	[TotalCost4] [money] NULL,
	[Markup4] [decimal](24, 4) NULL,
	[BillableCost4] [money] NULL,
	[Quantity5] [decimal](24, 4) NULL,
	[UnitCost5] [money] NULL,
	[UnitDescription5] [varchar](30) NULL,
	[TotalCost5] [money] NULL,
	[Markup5] [decimal](24, 4) NULL,
	[BillableCost5] [money] NULL,
	[Quantity6] [decimal](24, 4) NULL,
	[UnitCost6] [money] NULL,
	[UnitDescription6] [varchar](30) NULL,
	[TotalCost6] [money] NULL,
	[Markup6] [decimal](24, 4) NULL,
	[BillableCost6] [money] NULL,
	[Taxable2] [tinyint] NULL,
	[PurchaseOrderDetailKey] [int] NULL,
	[VendorKey] [int] NULL,
	[ClassKey] [int] NULL,
	[QuoteDetailKey] [int] NULL,
	[UnitRate] [money] NULL,
	[UnitRate2] [money] NULL,
	[UnitRate3] [money] NULL,
	[UnitRate4] [money] NULL,
	[UnitRate5] [money] NULL,
	[UnitRate6] [money] NULL,
	[Height] [decimal](24, 4) NULL,
	[Height2] [decimal](24, 4) NULL,
	[Height3] [decimal](24, 4) NULL,
	[Height4] [decimal](24, 4) NULL,
	[Height5] [decimal](24, 4) NULL,
	[Height6] [decimal](24, 4) NULL,
	[Width] [decimal](24, 4) NULL,
	[Width2] [decimal](24, 4) NULL,
	[Width3] [decimal](24, 4) NULL,
	[Width4] [decimal](24, 4) NULL,
	[Width5] [decimal](24, 4) NULL,
	[Width6] [decimal](24, 4) NULL,
	[ConversionMultiplier] [decimal](24, 4) NULL,
	[ConversionMultiplier2] [decimal](24, 4) NULL,
	[ConversionMultiplier3] [decimal](24, 4) NULL,
	[ConversionMultiplier4] [decimal](24, 4) NULL,
	[ConversionMultiplier5] [decimal](24, 4) NULL,
	[ConversionMultiplier6] [decimal](24, 4) NULL,
	[CampaignSegmentKey] [int] NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_tEstimateTaskExpense] PRIMARY KEY NONCLUSTERED 
(
	[EstimateTaskExpenseKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tEstimateTaskExpense]  WITH CHECK ADD  CONSTRAINT [FK_tEstimateTaskExpense_tEstimate] FOREIGN KEY([EstimateKey])
REFERENCES [dbo].[tEstimate] ([EstimateKey])
GO
ALTER TABLE [dbo].[tEstimateTaskExpense] CHECK CONSTRAINT [FK_tEstimateTaskExpense_tEstimate]
GO
