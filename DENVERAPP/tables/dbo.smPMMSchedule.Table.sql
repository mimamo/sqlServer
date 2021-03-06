USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[smPMMSchedule]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smPMMSchedule](
	[Calendar] [smallint] NOT NULL,
	[CalendarCode] [char](10) NOT NULL,
	[CalendarInterval] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EstTime] [char](4) NOT NULL,
	[IntervalCode] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[ManufID] [char](10) NOT NULL,
	[MeterTypeID] [char](10) NOT NULL,
	[ModelID] [char](40) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PMType] [char](10) NOT NULL,
	[Usage] [smallint] NOT NULL,
	[UsageInterval] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
