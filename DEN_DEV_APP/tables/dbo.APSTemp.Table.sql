USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[APSTemp]    Script Date: 12/21/2015 14:05:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[APSTemp](
	[Profit Ctr] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[Batch] [nvarchar](255) NULL,
	[Fiscal] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Description] [nvarchar](255) NULL,
	[Amount] [float] NULL,
	[Job] [nvarchar](255) NULL,
	[ClientCode] [varchar](10) NULL,
	[BillingCustomer] [varchar](150) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
