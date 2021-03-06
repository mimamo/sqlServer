USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarAttendee]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCalendarAttendee](
	[CalendarAttendeeKey] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_tCalendarAttendee] PRIMARY KEY NONCLUSTERED 
(
	[CalendarAttendeeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCalendarAttendee] ADD  CONSTRAINT [DF_tCalendarAttendee_Optional]  DEFAULT ((0)) FOR [Optional]
GO
ALTER TABLE [dbo].[tCalendarAttendee] ADD  CONSTRAINT [DF_tCalendarAttendee_IsDistributionGroup]  DEFAULT ((0)) FOR [IsDistributionGroup]
GO
