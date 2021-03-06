USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDAFile]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDAFile](
	[FileKey] [int] IDENTITY(1,1) NOT NULL,
	[FolderKey] [int] NULL,
	[ClientFolderKey] [int] NULL,
	[FileName] [varchar](300) NULL,
	[Description] [varchar](4000) NULL,
	[TrackRevisions] [tinyint] NOT NULL,
	[RevisionsToKeep] [int] NOT NULL,
	[CurrentVersionKey] [int] NOT NULL,
	[CheckedOutByKey] [int] NOT NULL,
	[CheckedOutDate] [smalldatetime] NULL,
	[CheckOutComment] [varchar](1000) NULL,
	[LockFile] [tinyint] NULL,
	[AddedDate] [smalldatetime] NULL,
	[AddedByKey] [int] NULL,
	[WebDavPath] [varchar](2000) NULL,
	[WebDavConversionLog] [text] NULL,
	[NewFileKey] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tDAFile] PRIMARY KEY CLUSTERED 
(
	[FileKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDAFile]  WITH CHECK ADD  CONSTRAINT [FK_tDAFile_tDAFolder] FOREIGN KEY([FolderKey])
REFERENCES [dbo].[tDAFolder] ([FolderKey])
GO
ALTER TABLE [dbo].[tDAFile] CHECK CONSTRAINT [FK_tDAFile_tDAFolder]
GO
ALTER TABLE [dbo].[tDAFile] ADD  CONSTRAINT [DF_tDAFile_CheckedOutByKey]  DEFAULT ((0)) FOR [CheckedOutByKey]
GO
ALTER TABLE [dbo].[tDAFile] ADD  CONSTRAINT [DF_tDAFile_LockDocument]  DEFAULT ((0)) FOR [LockFile]
GO
