USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xCustomNoteWatchListValueColorOption_Archive]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCustomNoteWatchListValueColorOption_Archive](
	[CustomNoteWatchListValueColorOption_ArchiveID] [uniqueidentifier] NOT NULL,
	[CustomNoteWatchListValueColorOptionID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[TimeLastModified] [datetime] NOT NULL,
	[ArchiveTimeCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_xCustomNoteWatchListValueColorOption_Archive] PRIMARY KEY CLUSTERED 
(
	[CustomNoteWatchListValueColorOption_ArchiveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PK' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xCustomNoteWatchListValueColorOption_Archive', @level2type=N'COLUMN',@level2name=N'CustomNoteWatchListValueColorOption_ArchiveID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name that represents the watch list value color option' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xCustomNoteWatchListValueColorOption_Archive', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Color value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xCustomNoteWatchListValueColorOption_Archive', @level2type=N'COLUMN',@level2name=N'Value'
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValueColorOption_Archive] ADD  CONSTRAINT [DF_xCustomNoteWatchListValueColorOption_Archive_CustomNoteWatchListValueColorOption_ArchiveID]  DEFAULT (newid()) FOR [CustomNoteWatchListValueColorOption_ArchiveID]
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValueColorOption_Archive] ADD  CONSTRAINT [DF_xCustomNoteWatchListValueColorOption_Archive_ArchiveTimeCreated]  DEFAULT (getdate()) FOR [ArchiveTimeCreated]
GO
