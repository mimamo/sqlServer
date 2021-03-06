USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyMediaContractClient]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompanyMediaContractClient](
	[CompanyMediaContractKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
 CONSTRAINT [PK_tCompanyMediaContractClient] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaContractKey] ASC,
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCompanyMediaContractClient]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaContractClient_tCompany] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tCompanyMediaContractClient] CHECK CONSTRAINT [FK_tCompanyMediaContractClient_tCompany]
GO
ALTER TABLE [dbo].[tCompanyMediaContractClient]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaContractClient_tCompanyMediaContract] FOREIGN KEY([CompanyMediaContractKey])
REFERENCES [dbo].[tCompanyMediaContract] ([CompanyMediaContractKey])
GO
ALTER TABLE [dbo].[tCompanyMediaContractClient] CHECK CONSTRAINT [FK_tCompanyMediaContractClient_tCompanyMediaContract]
GO
