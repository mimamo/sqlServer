USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCurrencyRate]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCurrencyRate](
	[CompanyKey] [int] NOT NULL,
	[GLCompanyKey] [int] NULL,
	[CurrencyID] [varchar](10) NOT NULL,
	[EffectiveDate] [smalldatetime] NOT NULL,
	[ExchangeRate] [decimal](24, 7) NOT NULL,
	[CurrencyRateKey] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tCurrencyRate] PRIMARY KEY CLUSTERED 
(
	[CurrencyRateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
