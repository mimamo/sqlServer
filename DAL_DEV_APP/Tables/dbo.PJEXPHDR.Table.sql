USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJEXPHDR]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEXPHDR](
	[advance_amt] [float] NOT NULL,
	[approver] [char](10) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[CpnyId_home] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[desc_hdr] [char](40) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[report_date] [smalldatetime] NOT NULL,
	[status_1] [char](1) NOT NULL,
	[status_2] [char](1) NOT NULL,
	[te_id01] [char](30) NOT NULL,
	[te_id02] [char](30) NOT NULL,
	[te_id03] [char](16) NOT NULL,
	[te_id04] [char](16) NOT NULL,
	[te_id05] [char](4) NOT NULL,
	[te_id06] [float] NOT NULL,
	[te_id07] [float] NOT NULL,
	[te_id08] [smalldatetime] NOT NULL,
	[te_id09] [smalldatetime] NOT NULL,
	[te_id10] [int] NOT NULL,
	[te_id11] [char](30) NOT NULL,
	[te_id12] [char](20) NOT NULL,
	[te_id13] [char](10) NOT NULL,
	[te_id14] [char](4) NOT NULL,
	[te_id15] [float] NOT NULL,
	[tripnbr] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjexphdr0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
