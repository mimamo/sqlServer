USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFieldSetField]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tFieldSetField](
	[FieldSetKey] [int] NOT NULL,
	[FieldDefKey] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_tFieldSetField] PRIMARY KEY NONCLUSTERED 
(
	[FieldSetKey] ASC,
	[FieldDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tFieldSetField]  WITH NOCHECK ADD  CONSTRAINT [FK_tFieldSetField_tFieldDef] FOREIGN KEY([FieldDefKey])
REFERENCES [dbo].[tFieldDef] ([FieldDefKey])
GO
ALTER TABLE [dbo].[tFieldSetField] CHECK CONSTRAINT [FK_tFieldSetField_tFieldDef]
GO
ALTER TABLE [dbo].[tFieldSetField]  WITH NOCHECK ADD  CONSTRAINT [FK_tFieldSetField_tFieldSet] FOREIGN KEY([FieldSetKey])
REFERENCES [dbo].[tFieldSet] ([FieldSetKey])
GO
ALTER TABLE [dbo].[tFieldSetField] CHECK CONSTRAINT [FK_tFieldSetField_tFieldSet]
GO
