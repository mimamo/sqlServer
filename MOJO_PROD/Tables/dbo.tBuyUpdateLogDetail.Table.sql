USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBuyUpdateLogDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBuyUpdateLogDetail](
	[BuyUpdateLogDetailKey] [uniqueidentifier] NOT NULL,
	[BuyUpdateLogKey] [bigint] NOT NULL,
	[PurchaseOrderKey] [int] NOT NULL,
	[Action] [char](1) NOT NULL,
	[PurchaseOrderDetailKey] [int] NULL,
	[LineType] [varchar](50) NULL,
	[DetailOrderDate] [smalldatetime] NULL,
	[MediaPremiumKey] [int] NULL,
	[PremiumAmountType] [varchar](50) NULL,
	[PremiumPct] [decimal](24, 4) NULL,
	[Quantity] [decimal](24, 4) NULL,
	[Quantity1] [decimal](24, 4) NULL,
	[Quantity2] [decimal](24, 4) NULL,
	[UnitRate] [money] NULL,
	[UnitCost] [money] NULL,
	[GrossAmount] [money] NULL,
	[Commission] [decimal](24, 4) NULL,
	[TotalCost] [money] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[TotalPremiumsNet] [money] NULL,
	[TotalPremiumsGross] [money] NULL,
	[TotalPremiumsTax1] [money] NULL,
	[TotalPremiumsTax2] [money] NULL,
	[TotalGross] [money] NULL,
	[TotalClient] [money] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[DetailData] [varchar](max) NULL,
 CONSTRAINT [PK_tBuyUpdateLogDetail] PRIMARY KEY CLUSTERED 
(
	[BuyUpdateLogDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tBuyUpdateLogDetail] ADD  CONSTRAINT [DF_tBuyUpdateLogDetail_BuyUpdateLogDetailKey]  DEFAULT (newid()) FOR [BuyUpdateLogDetailKey]
GO
