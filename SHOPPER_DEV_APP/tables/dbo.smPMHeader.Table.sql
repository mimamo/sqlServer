USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[smPMHeader]    Script Date: 12/21/2015 14:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smPMHeader](
	[calendar] [smallint] NOT NULL,
	[CalendarCode] [char](10) NOT NULL,
	[CalendarInterval] [float] NOT NULL,
	[CallTypeId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EstTime] [char](4) NOT NULL,
	[FaultCodeId] [char](10) NOT NULL,
	[IntervalCode] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MeterTypeID] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PMLevel] [smallint] NOT NULL,
	[PMType] [char](10) NOT NULL,
	[PMTypeDesc] [char](30) NOT NULL,
	[TechID] [char](10) NOT NULL,
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
