USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_VOID_Checks]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_VOID_Checks](
	[AdjgRefNbr] [char](10) NOT NULL,
	[AdjdRefNbr] [char](10) NOT NULL,
	[InvcNbr] [char](15) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[AdjgDocType] [char](2) NOT NULL,
	[AdjgDocDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
