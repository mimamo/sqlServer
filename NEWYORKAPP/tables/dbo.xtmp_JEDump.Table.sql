USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xtmp_JEDump]    Script Date: 12/21/2015 16:00:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmp_JEDump](
	[BatNbr] [char](10) NOT NULL,
	[BatchCrtd_datetime] [smalldatetime] NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[JrnlType] [char](3) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[BatType] [char](1) NOT NULL,
	[CuryCrAmt] [float] NOT NULL,
	[CuryDrAmt] [float] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[AutoRev] [smallint] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
