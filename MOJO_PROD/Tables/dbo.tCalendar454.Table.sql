USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendar454]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCalendar454](
	[CompanyKey] [int] NULL,
	[CalendarID] [varchar](50) NULL,
	[CalendarDate] [smalldatetime] NULL,
	[FiscalYear] [int] NULL,
	[FiscalQuarter] [smallint] NULL,
	[FiscalMonth] [smallint] NULL,
	[FiscalWeek] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
