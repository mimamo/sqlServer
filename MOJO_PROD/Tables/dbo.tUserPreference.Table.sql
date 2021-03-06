USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tUserPreference]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tUserPreference](
	[UserKey] [int] NOT NULL,
	[TimesheetRequired] [tinyint] NULL,
	[HoursMonday] [decimal](24, 4) NULL,
	[HoursTuesday] [decimal](24, 4) NULL,
	[HoursWednesday] [decimal](24, 4) NULL,
	[HoursThursday] [decimal](24, 4) NULL,
	[HoursFriday] [decimal](24, 4) NULL,
	[HoursSaturday] [decimal](24, 4) NULL,
	[HoursSunday] [decimal](24, 4) NULL,
	[EmailMailBox] [varchar](50) NULL,
	[EmailUserID] [varchar](50) NULL,
	[EmailPassword] [varchar](100) NULL,
	[EmailAttempts] [tinyint] NULL,
	[EmailLastSent] [datetime] NULL,
	[ExchangeOnlineServer] [varchar](500) NULL,
	[RequireMinimumHours] [tinyint] NULL,
	[PrivateUserToken] [varchar](2500) NULL,
	[PublicUserToken] [varchar](2500) NULL,
 CONSTRAINT [PK_tUserPreference] PRIMARY KEY NONCLUSTERED 
(
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
