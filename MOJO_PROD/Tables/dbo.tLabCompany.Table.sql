USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLabCompany]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tLabCompany](
	[LabKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
 CONSTRAINT [PK_tLabCompany] PRIMARY KEY CLUSTERED 
(
	[LabKey] ASC,
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
