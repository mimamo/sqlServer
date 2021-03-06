USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[XQCPR]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XQCPR](
	[RI_ID] [int] NOT NULL,
	[Customer] [varchar](15) NOT NULL,
	[Job] [varchar](15) NOT NULL,
	[Product_desc] [varchar](30) NOT NULL,
	[SortID] [int] NOT NULL,
	[SortName] [varchar](30) NOT NULL,
	[Current] [money] NOT NULL,
	[QTD] [money] NOT NULL,
	[YTD] [money] NOT NULL,
	[Hours] [float] NOT NULL,
	[pjt_entity] [char](32) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
