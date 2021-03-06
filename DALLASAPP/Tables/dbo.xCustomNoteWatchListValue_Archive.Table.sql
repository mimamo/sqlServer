USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xCustomNoteWatchListValue_Archive]    Script Date: 12/21/2015 13:44:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCustomNoteWatchListValue_Archive](
	[CustomNoteWatchListValue_ArchiveID] [uniqueidentifier] NOT NULL,
	[CustomNoteWatchListValueID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[TimeLastModified] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[LastModifiedBy] [nvarchar](50) NOT NULL,
	[ArchiveTimeCreated] [datetime] NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[CustomNoteWatchListValueColorOptionID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_xCustomNoteWatchListValue_Archive] PRIMARY KEY CLUSTERED 
(
	[CustomNoteWatchListValue_ArchiveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This field is a reference to the row in the xCustomNoteWatchListValueColorOption table that represents the color that will be used when displaying rows for the custom notes that are tied to this custom note watch list value in reports.  If this field is null then no color will be used for custom note rows tied to this custom note watch list value.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xCustomNoteWatchListValue_Archive', @level2type=N'COLUMN',@level2name=N'CustomNoteWatchListValueColorOptionID'
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValue_Archive] ADD  CONSTRAINT [DF_xCustomNoteWatchListValue_Archive_CustomNoteWatchListValue_ArchiveID]  DEFAULT (newid()) FOR [CustomNoteWatchListValue_ArchiveID]
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValue_Archive] ADD  CONSTRAINT [DF_xCustomNoteWatchListValue_Archive_ArchiveTimeCreated]  DEFAULT (getdate()) FOR [ArchiveTimeCreated]
GO
