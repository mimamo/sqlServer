USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrderTraffic]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPurchaseOrderTraffic](
	[PurchaseOrderTrafficKey] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseOrderKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[ISCICode] [varchar](100) NULL,
	[ShowPercent] [decimal](24, 4) NOT NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[Comments] [varchar](2000) NULL,
 CONSTRAINT [PK_tPurchaseOrderTraffic] PRIMARY KEY CLUSTERED 
(
	[PurchaseOrderTrafficKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPurchaseOrderTraffic]  WITH NOCHECK ADD  CONSTRAINT [FK_tPurchaseOrderTraffic_tPurchaseOrder] FOREIGN KEY([PurchaseOrderKey])
REFERENCES [dbo].[tPurchaseOrder] ([PurchaseOrderKey])
GO
ALTER TABLE [dbo].[tPurchaseOrderTraffic] CHECK CONSTRAINT [FK_tPurchaseOrderTraffic_tPurchaseOrder]
GO
