USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[smConPMTask]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smConPMTask](
	[CallDate] [smalldatetime] NOT NULL,
	[CallGenerated] [smallint] NOT NULL,
	[CallNbr] [char](10) NOT NULL,
	[ContractId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EquipId] [char](10) NOT NULL,
	[EstTime] [char](4) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[PMCode] [char](10) NOT NULL,
	[PMDate] [smalldatetime] NOT NULL,
	[PMUseReading] [float] NOT NULL,
	[PT_ID01] [char](30) NOT NULL,
	[PT_ID02] [char](30) NOT NULL,
	[PT_ID03] [char](20) NOT NULL,
	[PT_ID04] [char](20) NOT NULL,
	[PT_ID05] [char](10) NOT NULL,
	[PT_ID06] [char](10) NOT NULL,
	[PT_ID07] [char](4) NOT NULL,
	[PT_ID08] [float] NOT NULL,
	[PT_ID09] [smalldatetime] NOT NULL,
	[PT_ID10] [smallint] NOT NULL,
	[SchedDate] [smalldatetime] NOT NULL,
	[Technician] [char](10) NOT NULL,
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
