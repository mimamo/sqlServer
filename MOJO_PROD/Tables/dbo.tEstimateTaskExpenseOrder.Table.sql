USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskExpenseOrder]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTaskExpenseOrder](
	[EstimateTaskExpenseKey] [int] NOT NULL,
	[PurchaseOrderDetailKey] [int] NOT NULL
) ON [PRIMARY]
GO
