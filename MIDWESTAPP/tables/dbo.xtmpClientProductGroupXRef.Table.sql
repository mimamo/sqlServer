USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xtmpClientProductGroupXRef]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpClientProductGroupXRef](
	[ClientCode] [varchar](255) NULL,
	[dslClientCode] [varchar](255) NULL,
	[ProductCode] [varchar](255) NULL,
	[dslProductCode] [varchar](255) NULL,
	[Group] [varchar](255) NULL,
	[ProductName] [varchar](255) NULL,
	[plUnitCode] [varchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
