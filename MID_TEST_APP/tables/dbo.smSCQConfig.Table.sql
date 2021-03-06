USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[smSCQConfig]    Script Date: 12/21/2015 14:26:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smSCQConfig](
	[BranchID] [char](10) NOT NULL,
	[BranchIDAll] [smallint] NOT NULL,
	[ConfigCode] [char](10) NOT NULL,
	[ConfigColorMinutes] [smallint] NOT NULL,
	[ConfigColorOn] [char](1) NOT NULL,
	[ConfigDescription] [char](30) NOT NULL,
	[ConfigPriorityBlink] [char](1) NOT NULL,
	[ConfigPTimeBlink] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[PriorityHigh] [smallint] NOT NULL,
	[Prioritylow] [smallint] NOT NULL,
	[PriorityMedium] [smallint] NOT NULL,
	[PriorityPremium] [smallint] NOT NULL,
	[Technician] [char](10) NOT NULL,
	[TechnicianAll] [smallint] NOT NULL,
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
