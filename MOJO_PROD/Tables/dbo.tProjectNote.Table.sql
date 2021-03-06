USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectNote]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectNote](
	[ProjectNoteKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[ParentNoteKey] [int] NULL,
	[AddedByKey] [int] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[Note] [text] NULL,
	[VisibleToClient] [tinyint] NULL,
	[AddedByEmail] [varchar](300) NULL,
 CONSTRAINT [PK_tProjectNote] PRIMARY KEY CLUSTERED 
(
	[ProjectNoteKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectNote] ADD  CONSTRAINT [DF_tProjectNote_ParentNoteKey]  DEFAULT ((0)) FOR [ParentNoteKey]
GO
ALTER TABLE [dbo].[tProjectNote] ADD  CONSTRAINT [DF_tProjectNote_VisibleToClient]  DEFAULT ((1)) FOR [VisibleToClient]
GO
