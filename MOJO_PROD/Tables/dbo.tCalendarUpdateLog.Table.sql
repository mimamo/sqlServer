USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarUpdateLog]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCalendarUpdateLog](
	[CalendarKey] [int] NULL,
	[UserKey] [int] NOT NULL,
	[Action] [char](1) NOT NULL,
	[ActionDate] [smalldatetime] NOT NULL,
	[StoredProc] [varchar](50) NULL,
	[ParameterList] [varchar](1500) NULL,
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
	[OriginalEnd] [smalldatetime] NULL,
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
	[BySetPos] [int] NULL,
	[ByMonthDay] [int] NULL,
	[ByMonth] [int] NULL,
	[Su] [tinyint] NULL,
	[Mo] [tinyint] NULL,
	[Tu] [tinyint] NULL,
	[We] [tinyint] NULL,
	[Th] [tinyint] NULL,
	[Fr] [tinyint] NULL,
	[Sa] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[CMFolderKey] [int] NULL,
	[Private] [tinyint] NULL,
	[UID] [varchar](200) NULL,
	[Application] [varchar](200) NULL,
	[CalendarUpdateLogKey] [int] IDENTITY(1,1) NOT NULL,
	[GoogleUID] [varchar](200) NULL,
	[Exchange2010UID] [varchar](200) NULL,
 CONSTRAINT [PK_tCalendarUpdateLog] PRIMARY KEY CLUSTERED 
(
	[CalendarUpdateLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCalendarUpdateLog] ADD  CONSTRAINT [DF_tCalendarUpdateLog_ActionDate]  DEFAULT (getutcdate()) FOR [ActionDate]
GO
