USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSyncCalendarAttendee]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSyncCalendarAttendee](
	[CalendarKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Email] [varchar](200) NULL,
	[Status] [smallint] NOT NULL,
	[NoticeSent] [tinyint] NULL,
	[Comments] [varchar](4000) NULL,
	[Optional] [tinyint] NULL,
	[IsDistributionGroup] [tinyint] NULL,
	[CMFolderKey] [int] NULL,
	[Action] [varchar](5) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
