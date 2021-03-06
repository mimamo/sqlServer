USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[smSvcType]    Script Date: 12/21/2015 14:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smSvcType](
	[AgeCode] [char](10) NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSubAcct] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EquipmentTypeID] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[RevAcct] [char](10) NOT NULL,
	[RevSubAcct] [char](24) NOT NULL,
	[ScheduleType] [char](1) NOT NULL,
	[TypeDescr] [char](30) NOT NULL,
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
