USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSyncCalendar]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSyncCalendar](
	[CalendarKey] [int] NOT NULL,
	[Subject] [varchar](100) NULL,
	[Location] [varchar](100) NULL,
	[Description] [varchar](4000) NULL,
	[ProjectKey] [int] NULL,
	[CompanyKey] [int] NULL,
	[Visibility] [smallint] NULL,
	[Recurring] [tinyint] NULL,
	[RecurringCount] [int] NULL,
	[ReminderTime] [int] NULL,
	[ContactCompanyKey] [int] NULL,
	[ContactUserKey] [int] NULL,
	[ContactLeadKey] [int] NULL,
	[CalendarTypeKey] [int] NULL,
	[ReminderSent] [tinyint] NULL,
	[EventLevel] [int] NULL,
	[EventStart] [datetime] NULL,
	[EventEnd] [datetime] NULL,
	[ShowTimeAs] [int] NULL,
	[RecurringSettings] [varchar](500) NULL,
	[RecurringEndType] [varchar](50) NULL,
	[RecurringEndDate] [smalldatetime] NULL,
	[OriginalStart] [smalldatetime] NULL,
	[ParentKey] [int] NULL,
	[Pattern] [int] NULL,
	[Deleted] [tinyint] NULL,
	[AllDayEvent] [tinyint] NULL,
	[BlockOutOnSchedule] [tinyint] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[DateCreated] [datetime] NULL,
	[Sequence] [int] NULL,
	[CreatedBy] [int] NULL,
	[Freq] [varchar](25) NULL,
	[Interval] [int] NULL,
	[ByMonthDay] [int] NULL,
	[Su] [tinyint] NULL,
	[Mo] [tinyint] NULL,
	[Tu] [tinyint] NULL,
	[We] [tinyint] NULL,
	[Th] [tinyint] NULL,
	[Fr] [tinyint] NULL,
	[Sa] [tinyint] NULL,
	[LastModified] [smalldatetime] NULL,
	[BySetPos] [int] NULL,
	[ByMonth] [int] NULL,
	[CMFolderKey] [int] NULL,
	[Private] [tinyint] NULL,
	[OriginalEnd] [smalldatetime] NULL,
	[UID] [varchar](200) NOT NULL,
	[GoogleUID] [varchar](200) NULL,
	[Exchange2010UID] [varchar](200) NULL,
	[OriginalUID] [varchar](200) NULL,
	[CreatedByApplication] [varchar](200) NULL,
	[Processing] [tinyint] NULL,
	[ProcessingID] [varchar](100) NULL,
 CONSTRAINT [PK_tSyncCalendar] PRIMARY KEY CLUSTERED 
(
	[CalendarKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
