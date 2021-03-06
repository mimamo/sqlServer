USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xPA940]    Script Date: 12/21/2015 14:33:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xPA940](
	[RI_ID] [int] NOT NULL,
	[Customer] [varchar](15) NOT NULL,
	[Job] [varchar](15) NOT NULL,
	[Product_desc] [varchar](30) NOT NULL,
	[SortID] [int] NOT NULL,
	[SortName] [varchar](30) NOT NULL,
	[Current] [money] NOT NULL,
	[QTD] [money] NOT NULL,
	[YTD] [money] NOT NULL,
	[Hours] [float] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
