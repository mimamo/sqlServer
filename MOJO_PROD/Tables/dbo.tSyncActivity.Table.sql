USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSyncActivity]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSyncActivity](
	[UserKey] [int] NULL,
	[SessionID] [varchar](500) NULL,
	[LastSync] [datetime] NULL,
	[SourceURI] [varchar](1000) NULL,
	[CompanyKey] [int] NULL,
	[ToDeviceData] [text] NULL,
	[CMFolderKey] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSyncActivity] ADD  CONSTRAINT [DF_tSyncActivities_LastSync]  DEFAULT (getdate()) FOR [LastSync]
GO
