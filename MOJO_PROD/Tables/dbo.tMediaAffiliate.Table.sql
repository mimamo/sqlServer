USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaAffiliate]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaAffiliate](
	[MediaAffiliateKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[AffiliateID] [varchar](50) NOT NULL,
	[AffiliateName] [varchar](200) NOT NULL,
	[Active] [tinyint] NOT NULL,
 CONSTRAINT [PK_tMediaAffiliate] PRIMARY KEY CLUSTERED 
(
	[MediaAffiliateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
