USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrderUser]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPurchaseOrderUser](
	[PurchaseOrderKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[NotificationSent] [smallint] NULL
) ON [PRIMARY]
GO
