USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSyncItem]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSyncItem](
	[CompanyKey] [int] NULL,
	[ApplicationItemKey] [int] NULL,
	[ApplicationFolderKey] [int] NULL,
	[ApplicationDeletion] [tinyint] NULL,
	[DataStoreItemID] [varchar](2500) NULL,
	[DataStoreFolderID] [varchar](2500) NULL,
	[DataStoreDeletion] [tinyint] NULL,
	[LastSync] [datetime] NOT NULL,
	[UID] [varchar](200) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSyncItem] ADD  CONSTRAINT [DF_tItem_LastSync]  DEFAULT (getutcdate()) FOR [LastSync]
GO
