USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFinancialInstitution]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFinancialInstitution](
	[FinancialInstitutionKey] [int] NOT NULL,
	[FIName] [varchar](100) NOT NULL,
	[FIID] [varchar](50) NOT NULL,
	[FIOrg] [varchar](50) NOT NULL,
	[FIUrl] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tFinancialInstitution] PRIMARY KEY CLUSTERED 
(
	[FinancialInstitutionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
