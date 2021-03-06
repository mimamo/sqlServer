USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCMFolder]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCMFolder](
	[CMFolderKey] [int] IDENTITY(1,1) NOT NULL,
	[FolderName] [varchar](200) NOT NULL,
	[ParentFolderKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[SyncFolderKey] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[URL] [varchar](1000) NULL,
	[BlockoutAttendees] [tinyint] NULL,
	[CalendarColor] [varchar](50) NULL,
	[GoogleUserID] [varchar](100) NULL,
	[GooglePassword] [varchar](250) NULL,
	[GoogleSyncFolderKey] [int] NULL,
	[GoogleLoginAttempts] [tinyint] NULL,
	[GoogleLastEmailSent] [datetime] NULL,
	[GoogleAccessCode] [varchar](2000) NULL,
	[GoogleRefreshToken] [varchar](2000) NULL,
	[GoogleCalDAVEnabled] [tinyint] NULL,
	[GoogleCalDAVPublicUserKey] [int] NULL,
 CONSTRAINT [PK_tCMFolder] PRIMARY KEY CLUSTERED 
(
	[CMFolderKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCMFolder] ADD  CONSTRAINT [DF_tCMFolder_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
