USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectNoteLink]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectNoteLink](
	[ProjectNoteKey] [int] NOT NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectNoteLink]  WITH CHECK ADD  CONSTRAINT [FK_tProjectNoteLink_tProjectNote] FOREIGN KEY([ProjectNoteKey])
REFERENCES [dbo].[tProjectNote] ([ProjectNoteKey])
GO
ALTER TABLE [dbo].[tProjectNoteLink] CHECK CONSTRAINT [FK_tProjectNoteLink_tProjectNote]
GO
