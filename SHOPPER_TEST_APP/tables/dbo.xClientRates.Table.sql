USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xClientRates]    Script Date: 12/21/2015 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xClientRates](
	[ID] [int] NOT NULL,
	[Client] [nchar](10) NOT NULL,
	[Agency_Fee] [decimal](18, 4) NULL,
	[Digital_Fee] [decimal](18, 4) NULL
) ON [PRIMARY]
GO
