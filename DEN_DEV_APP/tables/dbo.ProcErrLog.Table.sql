USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[ProcErrLog]    Script Date: 12/21/2015 14:05:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProcErrLog](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[ErrDesc] [char](1020) NOT NULL,
	[ErrNo] [int] NOT NULL,
	[ExecString] [char](510) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[RecordID] [int] NOT NULL,
	[SortKey] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
