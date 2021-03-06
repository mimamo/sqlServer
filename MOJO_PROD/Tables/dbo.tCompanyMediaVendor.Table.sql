USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyMediaVendor]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompanyMediaVendor](
	[CompanyMediaKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
 CONSTRAINT [PK_tCompanyMediaVendor] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaKey] ASC,
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCompanyMediaVendor]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaVendor_tCompany] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tCompanyMediaVendor] CHECK CONSTRAINT [FK_tCompanyMediaVendor_tCompany]
GO
ALTER TABLE [dbo].[tCompanyMediaVendor]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaVendor_tCompanyMedia] FOREIGN KEY([CompanyMediaKey])
REFERENCES [dbo].[tCompanyMedia] ([CompanyMediaKey])
GO
ALTER TABLE [dbo].[tCompanyMediaVendor] CHECK CONSTRAINT [FK_tCompanyMediaVendor_tCompanyMedia]
GO
