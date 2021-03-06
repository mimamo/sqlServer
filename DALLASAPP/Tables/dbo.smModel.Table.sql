USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[smModel]    Script Date: 12/21/2015 13:44:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smModel](
	[AgeCode] [char](10) NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSubAcct] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Depth] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[EquipmentType] [char](10) NOT NULL,
	[Height] [float] NOT NULL,
	[Labor] [smallint] NOT NULL,
	[LaborIncl] [smallint] NOT NULL,
	[LaborType] [char](1) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[ManufId] [char](10) NOT NULL,
	[Material] [smallint] NOT NULL,
	[MaterialIncl] [smallint] NOT NULL,
	[MaterialType] [char](1) NOT NULL,
	[ModelId] [char](40) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PMCode] [char](10) NOT NULL,
	[Price] [float] NOT NULL,
	[RevAcct] [char](10) NOT NULL,
	[RevSubAcct] [char](24) NOT NULL,
	[RMARequired] [smallint] NOT NULL,
	[SkillId] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Weight] [float] NOT NULL,
	[Width] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
