USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[CMSetup]    Script Date: 12/21/2015 13:56:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CMSetup](
	[APCuryOverride] [smallint] NOT NULL,
	[APRateDate] [char](1) NOT NULL,
	[APRtTpDflt] [char](6) NOT NULL,
	[APRtTpOverride] [smallint] NOT NULL,
	[ARCuryOverride] [smallint] NOT NULL,
	[ARPrcLvlRtTp] [char](6) NOT NULL,
	[ARRateDate] [char](1) NOT NULL,
	[ARRtTpDflt] [char](6) NOT NULL,
	[ARRtTpOverride] [smallint] NOT NULL,
	[CARtTpDflt] [char](6) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryWarning] [smallint] NOT NULL,
	[GLRevalRtTpDflt] [char](6) NOT NULL,
	[GLRtTpDflt] [char](6) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MCActivated] [smallint] NOT NULL,
	[NoteId] [int] NOT NULL,
	[OERateDate] [char](1) NOT NULL,
	[OERateWarning] [smallint] NOT NULL,
	[RateVariance] [float] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[TriangCuryID] [char](4) NOT NULL,
	[TriangEffDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [CMSetup0] PRIMARY KEY CLUSTERED 
(
	[SetupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
