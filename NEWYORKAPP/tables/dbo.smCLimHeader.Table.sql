USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[smCLimHeader]    Script Date: 12/21/2015 16:00:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smCLimHeader](
	[CommOverAmount] [float] NOT NULL,
	[CommOverPct] [float] NOT NULL,
	[CommPlanId] [char](10) NOT NULL,
	[CommTypeId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
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
