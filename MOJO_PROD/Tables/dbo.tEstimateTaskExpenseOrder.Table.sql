USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskExpenseOrder]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTaskExpenseOrder](
	[EstimateTaskExpenseKey] [int] NOT NULL,
	[PurchaseOrderDetailKey] [int] NOT NULL
) ON [PRIMARY]
GO
