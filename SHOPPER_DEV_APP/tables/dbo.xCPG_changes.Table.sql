USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xCPG_changes]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xCPG_changes](
	[type] [int] NULL,
	[clientID] [varchar](255) NULL,
	[ClientName] [varchar](255) NULL,
	[clientStatus] [varchar](1) NULL,
	[ProdID] [varchar](255) NULL,
	[Product] [varchar](255) NULL,
	[ProductStatus] [varchar](1) NULL,
	[ProductGroup] [varchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
