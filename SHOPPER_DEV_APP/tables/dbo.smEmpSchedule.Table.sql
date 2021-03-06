USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[smEmpSchedule]    Script Date: 12/21/2015 14:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smEmpSchedule](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[EndTime] [char](4) NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[ES_ID01] [char](30) NOT NULL,
	[ES_ID02] [char](30) NOT NULL,
	[ES_ID03] [char](20) NOT NULL,
	[ES_ID04] [char](20) NOT NULL,
	[ES_ID05] [char](10) NOT NULL,
	[ES_ID06] [char](10) NOT NULL,
	[ES_ID07] [char](4) NOT NULL,
	[ES_ID08] [float] NOT NULL,
	[ES_ID09] [smalldatetime] NOT NULL,
	[ES_ID10] [int] NOT NULL,
	[ES_ID11] [char](30) NOT NULL,
	[ES_ID12] [char](30) NOT NULL,
	[ES_ID13] [char](20) NOT NULL,
	[ES_ID14] [char](20) NOT NULL,
	[ES_ID15] [char](10) NOT NULL,
	[ES_ID16] [char](10) NOT NULL,
	[ES_ID17] [char](4) NOT NULL,
	[ES_ID18] [float] NOT NULL,
	[ES_ID19] [smalldatetime] NOT NULL,
	[ES_ID20] [smallint] NOT NULL,
	[LastUpd_DateTime] [char](20) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[StartTime] [char](4) NOT NULL,
	[Status] [smallint] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
