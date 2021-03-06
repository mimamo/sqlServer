USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[BRImportSetup]    Script Date: 12/21/2015 14:10:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BRImportSetup](
	[AcctLen] [smallint] NOT NULL,
	[AcctPos] [smallint] NOT NULL,
	[AmtLen] [smallint] NOT NULL,
	[AmtPos] [smallint] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateLen] [smallint] NOT NULL,
	[DatePos] [smallint] NOT NULL,
	[DecimalPt] [char](1) NOT NULL,
	[DescrLen] [smallint] NOT NULL,
	[DescrPos] [smallint] NOT NULL,
	[Format] [smallint] NOT NULL,
	[Future01] [char](30) NOT NULL,
	[Future02] [char](10) NOT NULL,
	[Future03] [smalldatetime] NOT NULL,
	[Future04] [float] NOT NULL,
	[Future05] [int] NOT NULL,
	[Future06] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Process] [char](1) NOT NULL,
	[RefLen] [smallint] NOT NULL,
	[RefPos] [smallint] NOT NULL,
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
	[SetupID] [char](4) NOT NULL,
	[User01] [char](30) NOT NULL,
	[User02] [char](10) NOT NULL,
	[User03] [smalldatetime] NOT NULL,
	[User04] [float] NOT NULL,
	[User05] [int] NOT NULL,
	[User06] [smallint] NOT NULL,
	[TStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
