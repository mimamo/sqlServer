USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xtmpUnbillable]    Script Date: 12/21/2015 16:00:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpUnbillable](
	[Account Type] [nvarchar](255) NULL,
	[Module] [nvarchar](255) NULL,
	[Document Type] [nvarchar](255) NULL,
	[Batch] [nvarchar](255) NULL,
	[Fiscal] [nvarchar](255) NULL,
	[Reference] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Description] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
	[Client] [varchar](10) NULL,
	[Product] [varchar](30) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
