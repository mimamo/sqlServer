USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLAccountMultiCompanyPayments]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGLAccountMultiCompanyPayments](
	[CompanyKey] [int] NULL,
	[GLAccountKey] [int] NULL,
	[NextCheckNumber] [bigint] NULL,
	[DefaultCheckFormatKey] [int] NULL,
	[GLCompanyKey] [int] NULL
) ON [PRIMARY]
GO
