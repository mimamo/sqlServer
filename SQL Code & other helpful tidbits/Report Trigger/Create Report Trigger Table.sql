--run first on system database

/****** Object:  Table [dbo].[xRptRuntimeAudit]    Script Date: 09/15/2011 15:05:57 ******/

SET ANSI_NULLS ON

GO


SET QUOTED_IDENTIFIER ON

GO


SET ANSI_PADDING ON

GO

CREATE TABLE [dbo].[xRptRuntimeAudit](
	[AccessNbr] [char](5) NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Banner] [char](1) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BegPerNbr] [char](6) NOT NULL,
	[BusinessDate] [char](10) NOT NULL,
	[CmpnyName] [char](30) NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[DatabaseName] [char](20) NOT NULL,
	[DocNbr] [char](10) NOT NULL,
	[EndPerNbr] [char](6) NOT NULL,
	[LongAnswer00] [char](80) NOT NULL,
	[LongAnswer01] [char](80) NOT NULL,
	[LongAnswer02] [char](80) NOT NULL,
	[LongAnswer03] [char](80) NOT NULL,
	[LongAnswer04] [char](80) NOT NULL,
	[NotesOn] [smallint] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[RepBegDate] [smalldatetime] NOT NULL,
	[RepEndDate] [smalldatetime] NOT NULL,
	[ReportDate] [char](10) NOT NULL,
	[ReportFormat] [char](30) NOT NULL,
	[ReportName] [char](30) NOT NULL,
	[ReportNbr] [char](5) NOT NULL,
	[ReportTitle] [char](30) NOT NULL,
	[RI_BEGPAGE] [smallint] NOT NULL,
	[RI_CHKTIME] [char](1) NOT NULL,
	[RI_COPIES] [smallint] NOT NULL,
	[RI_DATADIR] [char](21) NOT NULL,
	[RI_DICTDIR] [char](21) NOT NULL,
	[RI_DISABLEDS] [smallint] NOT NULL,
	[RI_DISABLEQS] [smallint] NOT NULL,
	[RI_DISPERR] [char](1) NOT NULL,
	[RI_ENDPAGE] [smallint] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[RI_INCLUDE] [char](1) NOT NULL,
	[RI_LIBRARY] [char](80) NOT NULL,
	[RI_NOESC] [char](1) NOT NULL,
	[RI_OUTAPPN] [char](1) NOT NULL,
	[RI_OUTFILE] [char](255) NOT NULL,
	[RI_PRINTER] [char](1) NOT NULL,
	[RI_REPLACE] [char](255) NOT NULL,
	[RI_REPORT] [char](30) NOT NULL,
	[RI_STATUS] [char](1) NOT NULL,
	[RI_TEST] [char](1) NOT NULL,
	[RI_WHERE] [char](1024) NOT NULL,
	[RI_WPORT] [char](255) NOT NULL,
	[RI_WPTR] [char](255) NOT NULL,
	[RI_WTITLE] [char](30) NOT NULL,
	[SegCustMask] [char](16) NOT NULL,
	[SegCustTitle] [char](16) NOT NULL,
	[SegInvenMask] [char](26) NOT NULL,
	[SegInvenTitle] [char](26) NOT NULL,
	[SegSubMask] [char](38) NOT NULL,
	[SegSubTitle] [char](38) NOT NULL,
	[SegVendMask] [char](16) NOT NULL,
	[SegVendTitle] [char](16) NOT NULL,
	[ShortAnswer00] [char](10) NOT NULL,
	[ShortAnswer01] [char](10) NOT NULL,
	[ShortAnswer02] [char](10) NOT NULL,
	[ShortAnswer03] [char](10) NOT NULL,
	[ShortAnswer04] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[SystemDate] [char](10) NOT NULL,
	[SystemTime] [char](7) NOT NULL,
	[UserId] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
