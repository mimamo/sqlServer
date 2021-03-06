USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tNoteGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tNoteGroup](
	[NoteGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GroupName] [varchar](200) NOT NULL,
	[AssociatedEntity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[DisplayOrder] [int] NULL,
	[Active] [tinyint] NULL,
 CONSTRAINT [PK_tNoteGroup] PRIMARY KEY NONCLUSTERED 
(
	[NoteGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
