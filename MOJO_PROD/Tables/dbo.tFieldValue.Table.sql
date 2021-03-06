USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFieldValue]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFieldValue](
	[FieldValueKey] [uniqueidentifier] NOT NULL,
	[FieldDefKey] [int] NOT NULL,
	[ObjectFieldSetKey] [int] NOT NULL,
	[FieldValue] [varchar](8000) NULL,
 CONSTRAINT [PK_tFieldValue] PRIMARY KEY NONCLUSTERED 
(
	[FieldValueKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tFieldValue]  WITH NOCHECK ADD  CONSTRAINT [FK_tFieldValue_tFieldDef] FOREIGN KEY([FieldDefKey])
REFERENCES [dbo].[tFieldDef] ([FieldDefKey])
GO
ALTER TABLE [dbo].[tFieldValue] CHECK CONSTRAINT [FK_tFieldValue_tFieldDef]
GO
ALTER TABLE [dbo].[tFieldValue]  WITH NOCHECK ADD  CONSTRAINT [FK_tFieldValue_tObjectFieldSet1] FOREIGN KEY([ObjectFieldSetKey])
REFERENCES [dbo].[tObjectFieldSet] ([ObjectFieldSetKey])
GO
ALTER TABLE [dbo].[tFieldValue] CHECK CONSTRAINT [FK_tFieldValue_tObjectFieldSet1]
GO
