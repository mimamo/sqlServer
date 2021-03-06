USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyMediaPosition]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompanyMediaPosition](
	[CompanyMediaKey] [int] NOT NULL,
	[MediaPositionKey] [int] NOT NULL,
 CONSTRAINT [PK_tCompanyMediaPostion] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaKey] ASC,
	[MediaPositionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCompanyMediaPosition]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaPostion_tMediaPosition] FOREIGN KEY([MediaPositionKey])
REFERENCES [dbo].[tMediaPosition] ([MediaPositionKey])
GO
ALTER TABLE [dbo].[tCompanyMediaPosition] CHECK CONSTRAINT [FK_tCompanyMediaPostion_tMediaPosition]
GO
