USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tObjectFieldSet]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tObjectFieldSet](
	[ObjectFieldSetKey] [int] IDENTITY(1,1) NOT NULL,
	[FieldSetKey] [int] NOT NULL,
 CONSTRAINT [PK_tObjectFieldSet] PRIMARY KEY CLUSTERED 
(
	[ObjectFieldSetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tObjectFieldSet]  WITH NOCHECK ADD  CONSTRAINT [FK_tObjectFieldSet_tFieldSet] FOREIGN KEY([FieldSetKey])
REFERENCES [dbo].[tFieldSet] ([FieldSetKey])
GO
ALTER TABLE [dbo].[tObjectFieldSet] CHECK CONSTRAINT [FK_tObjectFieldSet_tFieldSet]
GO
