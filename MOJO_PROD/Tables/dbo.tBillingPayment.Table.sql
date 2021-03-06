USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBillingPayment]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBillingPayment](
	[BillingPaymentKey] [int] IDENTITY(1,1) NOT NULL,
	[BillingKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Amount] [money] NOT NULL,
 CONSTRAINT [PK_tBillingPayment] PRIMARY KEY CLUSTERED 
(
	[BillingPaymentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
