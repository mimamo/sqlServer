USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xrf_VendorXRef]    Script Date: 12/21/2015 16:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xrf_VendorXRef](
	[SolVendID] [nvarchar](255) NULL,
	[VendorCode] [nvarchar](255) NULL,
	[VendorID] [nvarchar](255) NULL
) ON [PRIMARY]
GO
