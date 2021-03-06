USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJALLOC]    Script Date: 12/21/2015 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJALLOC](
	[alloc_basis] [char](2) NOT NULL,
	[alloc_calc_type] [char](2) NOT NULL,
	[alloc_method_cd] [char](4) NOT NULL,
	[alloc_rate] [float] NOT NULL,
	[al_id01] [char](16) NOT NULL,
	[al_id02] [char](16) NOT NULL,
	[al_id03] [char](4) NOT NULL,
	[al_id04] [char](4) NOT NULL,
	[al_id05] [char](1) NOT NULL,
	[al_id06] [char](1) NOT NULL,
	[al_id07] [char](1) NOT NULL,
	[al_id08] [char](1) NOT NULL,
	[al_id09] [char](1) NOT NULL,
	[al_id10] [char](1) NOT NULL,
	[begin_acct] [char](16) NOT NULL,
	[begin_step] [smallint] NOT NULL,
	[bill_post_sw] [char](1) NOT NULL,
	[credit_cpnyId] [char](10) NOT NULL,
	[credit_gl_acct] [char](10) NOT NULL,
	[credit_gl_subacct] [char](24) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[debit_cpnyId] [char](10) NOT NULL,
	[debit_gl_acct] [char](10) NOT NULL,
	[debit_gl_subacct] [char](24) NOT NULL,
	[emp_recap_sw] [char](1) NOT NULL,
	[end_acct] [char](16) NOT NULL,
	[end_step] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[offset_acct] [char](16) NOT NULL,
	[offset_pjt_entity] [char](32) NOT NULL,
	[offset_project] [char](16) NOT NULL,
	[post_acct] [char](16) NOT NULL,
	[post_pjt_entity] [char](32) NOT NULL,
	[post_project] [char](16) NOT NULL,
	[rate_type_cd] [char](2) NOT NULL,
	[step_desc] [char](30) NOT NULL,
	[step_number] [smallint] NOT NULL,
	[subacct_recap_sw] [char](1) NOT NULL,
	[unit_post_sw] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjalloc0] PRIMARY KEY CLUSTERED 
(
	[alloc_method_cd] ASC,
	[step_number] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
