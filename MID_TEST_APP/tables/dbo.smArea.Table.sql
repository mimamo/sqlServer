USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[smArea]    Script Date: 12/21/2015 14:26:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smArea](
	[AreaAvgRevenue] [float] NOT NULL,
	[AreaDesc] [char](30) NOT NULL,
	[AreaId] [char](10) NOT NULL,
	[AreaNumOfCalls] [smallint] NOT NULL,
	[AreaTotalRevenue] [float] NOT NULL,
	[AssignEmployee] [char](10) NOT NULL,
	[Crtd_dateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
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
