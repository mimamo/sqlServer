USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSyncFolder]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSyncFolder](
	[SyncFolderKey] [int] IDENTITY(1,1) NOT NULL,
	[SyncFolderName] [varchar](500) NOT NULL,
	[FolderID] [varchar](2500) NULL,
	[UserKey] [int] NULL,
	[CompanyKey] [int] NULL,
	[Entity] [varchar](50) NOT NULL,
	[LastModified] [smalldatetime] NULL,
	[LastSync] [smalldatetime] NULL,
	[SyncDirection] [smallint] NULL,
	[SyncApp] [int] NULL,
	[GoogleLastSync] [smalldatetime] NULL,
	[IsProcessing] [tinyint] NULL,
 CONSTRAINT [PK_tSyncFolder] PRIMARY KEY CLUSTERED 
(
	[SyncFolderKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSyncFolder] ADD  CONSTRAINT [DF_tSyncFolder_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tSyncFolder] ADD  CONSTRAINT [DF_tSyncFolder_SyncApp]  DEFAULT ((0)) FOR [SyncApp]
GO
