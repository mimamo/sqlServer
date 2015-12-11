USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDAFolderRight]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDAFolderRight](
	[FolderKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[AllowRead] [tinyint] NOT NULL,
	[AllowAdd] [tinyint] NOT NULL,
	[AllowAddFile] [tinyint] NOT NULL,
	[AllowChange] [tinyint] NOT NULL,
	[AllowDelete] [tinyint] NOT NULL,
	[WebDavSecurityKey] [int] NULL,
 CONSTRAINT [PK_tDAFolderRight] PRIMARY KEY CLUSTERED 
(
	[FolderKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDAFolderRight]  WITH NOCHECK ADD  CONSTRAINT [FK_tDAFolderRight_tDAFolder] FOREIGN KEY([FolderKey])
REFERENCES [dbo].[tDAFolder] ([FolderKey])
GO
ALTER TABLE [dbo].[tDAFolderRight] CHECK CONSTRAINT [FK_tDAFolderRight_tDAFolder]
GO
ALTER TABLE [dbo].[tDAFolderRight] ADD  CONSTRAINT [DF_tDAFolderRight_AllowAddFile]  DEFAULT ((1)) FOR [AllowAddFile]
GO
