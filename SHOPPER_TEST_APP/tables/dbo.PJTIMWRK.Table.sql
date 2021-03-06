USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PJTIMWRK]    Script Date: 12/21/2015 16:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTIMWRK](
	[Corrections] [char](1) NOT NULL,
	[employee] [char](10) NOT NULL,
	[emp_name] [char](60) NOT NULL,
	[Hired] [smalldatetime] NOT NULL,
	[Linenbr] [smallint] NOT NULL,
	[Manager] [char](10) NOT NULL,
	[MgrName] [char](60) NOT NULL,
	[Org] [char](24) NOT NULL,
	[Report_accessnbr] [char](10) NOT NULL,
	[Select_By] [char](1) NOT NULL,
	[Status_select] [char](10) NOT NULL,
	[Status_01] [char](1) NOT NULL,
	[Status_02] [char](1) NOT NULL,
	[Status_03] [char](1) NOT NULL,
	[Status_04] [char](1) NOT NULL,
	[Status_05] [char](1) NOT NULL,
	[Status_06] [char](1) NOT NULL,
	[Supervisor] [char](10) NOT NULL,
	[SupName] [char](60) NOT NULL,
	[Term] [smalldatetime] NOT NULL,
	[WeekEnding] [smalldatetime] NOT NULL,
	[WeekEndingCol_01] [smalldatetime] NOT NULL,
	[WeekEndingCol_02] [smalldatetime] NOT NULL,
	[WeekEndingCol_03] [smalldatetime] NOT NULL,
	[WeekEndingCol_04] [smalldatetime] NOT NULL,
	[WeekEndingCol_05] [smalldatetime] NOT NULL,
	[WeekEndingCol_06] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtimwrk0] PRIMARY KEY CLUSTERED 
(
	[Report_accessnbr] ASC,
	[Linenbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
