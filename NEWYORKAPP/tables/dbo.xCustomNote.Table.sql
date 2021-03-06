USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xCustomNote]    Script Date: 12/21/2015 16:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCustomNote](
	[NoteID] [uniqueidentifier] NOT NULL,
	[ItemID] [nvarchar](20) NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[Subject] [nvarchar](100) NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[TimeLastModified] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[LastModifiedBy] [nvarchar](50) NOT NULL,
	[CustomNoteWatchListValueID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_xCustomNote] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[xCustomNote] ADD  CONSTRAINT [DF_xCustomNote_NoteID]  DEFAULT (newid()) FOR [NoteID]
GO
ALTER TABLE [dbo].[xCustomNote] ADD  CONSTRAINT [DF_xCustomNote_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[xCustomNote] ADD  CONSTRAINT [DF_xCustomNote_TimeLastModified]  DEFAULT (getdate()) FOR [TimeLastModified]
GO
ALTER TABLE [dbo].[xCustomNote] ADD  CONSTRAINT [DF_xCustomNote_CustomNoteWatchListValueID]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CustomNoteWatchListValueID]
GO
