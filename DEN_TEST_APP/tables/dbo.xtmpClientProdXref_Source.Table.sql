USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpClientProdXref_Source]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpClientProdXref_Source](
	[dslClientCode] [nvarchar](50) NULL,
	[Encoda PRODUCT_ID] [nvarchar](50) NULL,
	[productName] [nvarchar](50) NULL,
	[productCode] [nvarchar](50) NULL,
	[dslProductCode] [nvarchar](50) NULL,
	[Encoda CLIENT_ID] [nvarchar](50) NULL,
	[clientCode] [nvarchar](50) NULL,
	[plUnitCode] [nvarchar](50) NULL,
	[GROUP] [nvarchar](50) NULL,
	[Encoda Client Master 8-21 CLIENT_CODE Match] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[Sub Group] [nvarchar](50) NULL
) ON [PRIMARY]
GO
