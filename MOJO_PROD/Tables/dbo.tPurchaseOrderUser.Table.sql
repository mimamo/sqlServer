USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrderUser]    Script Date: 12/21/2015 16:17:51 ******/
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
