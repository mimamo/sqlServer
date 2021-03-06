USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PRREPCOL]    Script Date: 12/21/2015 13:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PRREPCOL](
	[ColumnBaseNbr00] [smallint] NOT NULL,
	[ColumnBaseNbr01] [smallint] NOT NULL,
	[ColumnBaseNbr02] [smallint] NOT NULL,
	[ColumnBaseNbr03] [smallint] NOT NULL,
	[ColumnBaseNbr04] [smallint] NOT NULL,
	[ColumnCaption00] [char](20) NOT NULL,
	[ColumnCaption01] [char](20) NOT NULL,
	[ColumnCaption02] [char](20) NOT NULL,
	[ColumnCaption03] [char](20) NOT NULL,
	[ColumnCaption04] [char](20) NOT NULL,
	[ColumnDedId00] [char](10) NOT NULL,
	[ColumnDedId01] [char](10) NOT NULL,
	[ColumnDedId02] [char](10) NOT NULL,
	[ColumnDedId03] [char](10) NOT NULL,
	[ColumnDedId04] [char](10) NOT NULL,
	[ColumnPct00] [float] NOT NULL,
	[ColumnPct01] [float] NOT NULL,
	[ColumnPct02] [float] NOT NULL,
	[ColumnPct03] [float] NOT NULL,
	[ColumnPct04] [float] NOT NULL,
	[ColumnType00] [char](1) NOT NULL,
	[ColumnType01] [char](1) NOT NULL,
	[ColumnType02] [char](1) NOT NULL,
	[ColumnType03] [char](1) NOT NULL,
	[ColumnType04] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[ReportFormat] [char](30) NOT NULL,
	[ReportName] [char](30) NOT NULL,
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
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PRREPCOL0] PRIMARY KEY CLUSTERED 
(
	[ReportName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
