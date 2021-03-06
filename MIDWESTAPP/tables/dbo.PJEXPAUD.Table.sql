USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PJEXPAUD]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEXPAUD](
	[amt_employ] [float] NOT NULL,
	[amt_company] [float] NOT NULL,
	[amt_tax] [float] NOT NULL,
	[CpnyId_chrg] [char](10) NOT NULL,
	[CpnyId_home] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTranamt] [float] NOT NULL,
	[desc_detail] [char](40) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[exp_date] [smalldatetime] NOT NULL,
	[exp_type] [char](4) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[payment_cd] [char](4) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[rate] [float] NOT NULL,
	[status] [char](1) NOT NULL,
	[td_id01] [char](30) NOT NULL,
	[td_id02] [char](30) NOT NULL,
	[td_id03] [char](16) NOT NULL,
	[td_id04] [char](16) NOT NULL,
	[td_id05] [char](4) NOT NULL,
	[td_id06] [float] NOT NULL,
	[td_id07] [float] NOT NULL,
	[td_id08] [smalldatetime] NOT NULL,
	[td_id09] [smalldatetime] NOT NULL,
	[td_id10] [int] NOT NULL,
	[td_id11] [char](30) NOT NULL,
	[td_id12] [char](20) NOT NULL,
	[td_id13] [char](10) NOT NULL,
	[td_id14] [char](4) NOT NULL,
	[td_id15] [float] NOT NULL,
	[unit_of_measure] [char](10) NOT NULL,
	[units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[vendor_num] [char](15) NOT NULL,
	[zaudit_seq] [int] IDENTITY(1,1) NOT NULL,
	[zaudit_type] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PJEXPAUD0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC,
	[linenbr] ASC,
	[zaudit_seq] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
