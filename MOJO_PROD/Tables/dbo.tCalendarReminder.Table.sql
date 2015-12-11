USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarReminder]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCalendarReminder](
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[EventMonth] [int] NOT NULL,
	[EventDay] [int] NOT NULL,
	[EventYear] [int] NOT NULL,
	[Displayed] [tinyint] NULL,
	[Dismissed] [tinyint] NULL,
	[SnoozeTime] [smalldatetime] NULL,
 CONSTRAINT [PK_tCalendarReminder_1] PRIMARY KEY CLUSTERED 
(
	[Entity] ASC,
	[EntityKey] ASC,
	[UserKey] ASC,
	[EventMonth] ASC,
	[EventDay] ASC,
	[EventYear] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCalendarReminder] ADD  CONSTRAINT [DF_tCalendarReminder_Entity]  DEFAULT ('tCalendar') FOR [Entity]
GO
