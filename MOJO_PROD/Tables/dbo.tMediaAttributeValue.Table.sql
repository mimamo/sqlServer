USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaAttributeValue]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaAttributeValue](
	[MediaAttributeValueKey] [int] IDENTITY(1,1) NOT NULL,
	[MediaAttributeKey] [int] NOT NULL,
	[ValueName] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_tMediaAttributeValue] PRIMARY KEY CLUSTERED 
(
	[MediaAttributeValueKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_tMediaAttributeValue_tMediaAttribute] FOREIGN KEY([MediaAttributeKey])
REFERENCES [dbo].[tMediaAttribute] ([MediaAttributeKey])
GO
ALTER TABLE [dbo].[tMediaAttributeValue] CHECK CONSTRAINT [FK_tMediaAttributeValue_tMediaAttribute]
GO
