USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xVendorMedia]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xVendorMedia](
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[VendID] [nvarchar](15) NOT NULL,
	[MediaType] [nvarchar](20) NOT NULL,
	[CallLetter] [nvarchar](4) NOT NULL,
	[MediaBand] [nvarchar](5) NOT NULL,
	[PublicationName] [nvarchar](max) NOT NULL,
	[MarketCity] [nvarchar](50) NOT NULL,
	[MarketState] [nvarchar](2) NOT NULL,
 CONSTRAINT [PK_xVendorMedia] PRIMARY KEY CLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
