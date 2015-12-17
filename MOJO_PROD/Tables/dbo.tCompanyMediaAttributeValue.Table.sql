USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyMediaAttributeValue]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompanyMediaAttributeValue](
	[CompanyMediaKey] [int] NOT NULL,
	[MediaAttributeValueKey] [int] NOT NULL,
 CONSTRAINT [PK_tCompanyMediaAttributeValue] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaKey] ASC,
	[MediaAttributeValueKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCompanyMediaAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaAttributeValue_tCompanyMedia] FOREIGN KEY([CompanyMediaKey])
REFERENCES [dbo].[tCompanyMedia] ([CompanyMediaKey])
GO
ALTER TABLE [dbo].[tCompanyMediaAttributeValue] CHECK CONSTRAINT [FK_tCompanyMediaAttributeValue_tCompanyMedia]
GO
ALTER TABLE [dbo].[tCompanyMediaAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaAttributeValue_tMediaAttributeValue] FOREIGN KEY([MediaAttributeValueKey])
REFERENCES [dbo].[tMediaAttributeValue] ([MediaAttributeValueKey])
GO
ALTER TABLE [dbo].[tCompanyMediaAttributeValue] CHECK CONSTRAINT [FK_tCompanyMediaAttributeValue_tMediaAttributeValue]
GO
