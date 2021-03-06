USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[ClientRates]    Script Date: 12/21/2015 14:33:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientRates](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Client] [nchar](10) NOT NULL,
	[Agency_Fee] [decimal](18, 0) NULL,
	[Digital_Fee] [decimal](18, 0) NULL,
 CONSTRAINT [PK_ClientRates] PRIMARY KEY CLUSTERED 
(
	[Client] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
