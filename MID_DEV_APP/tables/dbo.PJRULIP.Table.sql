USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJRULIP]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRULIP](
	[acct] [char](16) NOT NULL,
	[adj_cpnyid] [char](10) NOT NULL,
	[adj_gl_acct] [char](10) NOT NULL,
	[adj_gl_subacct] [char](24) NOT NULL,
	[bill_type_cd] [char](4) NOT NULL,
	[cpnyid] [char](10) NOT NULL,
	[credit_cpnyid] [char](10) NOT NULL,
	[credit_gl_acct] [char](10) NOT NULL,
	[credit_gl_subacct] [char](24) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[debit_cpnyid] [char](10) NOT NULL,
	[debit_gl_acct] [char](10) NOT NULL,
	[debit_gl_subacct] [char](24) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[rp_id01] [char](30) NOT NULL,
	[rp_id02] [char](30) NOT NULL,
	[rp_id03] [char](16) NOT NULL,
	[rp_id04] [char](16) NOT NULL,
	[rp_id05] [char](4) NOT NULL,
	[rp_id06] [char](4) NOT NULL,
	[rp_id07] [char](4) NOT NULL,
	[rp_id08] [char](4) NOT NULL,
	[rp_id09] [float] NOT NULL,
	[rp_id10] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrulip0] PRIMARY KEY CLUSTERED 
(
	[bill_type_cd] ASC,
	[acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
