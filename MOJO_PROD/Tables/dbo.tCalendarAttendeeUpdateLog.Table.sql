USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarAttendeeUpdateLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCalendarAttendeeUpdateLog](
	[CalendarUpdateLogKey] [int] NOT NULL,
	[CalendarAttendeeKey] [int] NULL,
	[CalendarKey] [int] NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[Email] [varchar](200) NULL,
	[Status] [smallint] NULL,
	[NoticeSent] [tinyint] NULL,
	[Comments] [varchar](4000) NULL,
	[Optional] [tinyint] NULL,
	[IsDistributionGroup] [tinyint] NULL,
	[CMFolderKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
