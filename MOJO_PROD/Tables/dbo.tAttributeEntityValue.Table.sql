USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAttributeEntityValue]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAttributeEntityValue](
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[AttributeValueKey] [int] NOT NULL,
 CONSTRAINT [PK_tAttributeEntityValue] PRIMARY KEY CLUSTERED 
(
	[Entity] ASC,
	[EntityKey] ASC,
	[AttributeValueKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAttributeEntityValue]  WITH NOCHECK ADD  CONSTRAINT [FK_tAttributeEntityValue_tAttributeValue] FOREIGN KEY([AttributeValueKey])
REFERENCES [dbo].[tAttributeValue] ([AttributeValueKey])
GO
ALTER TABLE [dbo].[tAttributeEntityValue] CHECK CONSTRAINT [FK_tAttributeEntityValue_tAttributeValue]
GO
