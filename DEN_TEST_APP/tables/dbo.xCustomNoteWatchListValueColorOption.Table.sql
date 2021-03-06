USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xCustomNoteWatchListValueColorOption]    Script Date: 12/21/2015 14:10:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCustomNoteWatchListValueColorOption](
	[CustomNoteWatchListValueColorOptionID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[TimeLastModified] [datetime] NOT NULL,
 CONSTRAINT [PK_xCustomNoteWatchListValueColorOption] PRIMARY KEY CLUSTERED 
(
	[CustomNoteWatchListValueColorOptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name that represents the watch list value color option' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xCustomNoteWatchListValueColorOption', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Color value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xCustomNoteWatchListValueColorOption', @level2type=N'COLUMN',@level2name=N'Value'
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValueColorOption] ADD  CONSTRAINT [DF_xCustomNoteWatchListValueColorOption_CustomNoteWatchListValueColorOptionID]  DEFAULT (newid()) FOR [CustomNoteWatchListValueColorOptionID]
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValueColorOption] ADD  CONSTRAINT [DF_xCustomNoteWatchListValueColorOption_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[xCustomNoteWatchListValueColorOption] ADD  CONSTRAINT [DF_xCustomNoteWatchListValueColorOption_TimeLastModified]  DEFAULT (getdate()) FOR [TimeLastModified]
GO
