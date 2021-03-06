USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAttributeValue]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAttributeValue](
	[AttributeValueKey] [int] IDENTITY(1,1) NOT NULL,
	[AttributeKey] [int] NOT NULL,
	[AttributeValue] [varchar](200) NOT NULL,
 CONSTRAINT [PK_tAttributeValue] PRIMARY KEY CLUSTERED 
(
	[AttributeValueKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [FK_tAttributeValue_tAttribute] FOREIGN KEY([AttributeKey])
REFERENCES [dbo].[tAttribute] ([AttributeKey])
GO
ALTER TABLE [dbo].[tAttributeValue] CHECK CONSTRAINT [FK_tAttributeValue_tAttribute]
GO
