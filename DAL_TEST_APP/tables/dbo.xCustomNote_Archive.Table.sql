USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xCustomNote_Archive]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCustomNote_Archive](
	[CustomNote_ArchiveID] [uniqueidentifier] NOT NULL,
	[NoteID] [uniqueidentifier] NOT NULL,
	[ItemID] [nvarchar](20) NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[Subject] [nvarchar](100) NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[TimeLastModified] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[LastModifiedBy] [nvarchar](50) NOT NULL,
	[ArchiveTimeCreated] [datetime] NOT NULL,
	[CustomNoteWatchListValueID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_xCustomNote_Archive] PRIMARY KEY CLUSTERED 
(
	[CustomNote_ArchiveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[xCustomNote_Archive] ADD  CONSTRAINT [DF_xCustomNote_Archive_xCustomNote_ArchiveID]  DEFAULT (newid()) FOR [CustomNote_ArchiveID]
GO
ALTER TABLE [dbo].[xCustomNote_Archive] ADD  CONSTRAINT [DF_xCustomNote_Archive_ArchiveTimeCreated]  DEFAULT (getdate()) FOR [ArchiveTimeCreated]
GO
