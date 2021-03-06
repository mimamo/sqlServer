USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDAFileRight]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDAFileRight](
	[FileKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[AllowRead] [tinyint] NOT NULL,
	[AllowUpdate] [tinyint] NOT NULL,
	[AllowChange] [tinyint] NOT NULL,
	[AllowDelete] [tinyint] NOT NULL,
 CONSTRAINT [PK_tDAFileRight] PRIMARY KEY CLUSTERED 
(
	[FileKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDAFileRight]  WITH CHECK ADD  CONSTRAINT [FK_tDAFileRight_tDAFile] FOREIGN KEY([FileKey])
REFERENCES [dbo].[tDAFile] ([FileKey])
GO
ALTER TABLE [dbo].[tDAFileRight] CHECK CONSTRAINT [FK_tDAFileRight_tDAFile]
GO
