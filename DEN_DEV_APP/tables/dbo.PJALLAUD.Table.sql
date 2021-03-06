USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PJALLAUD]    Script Date: 12/21/2015 14:05:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJALLAUD](
	[alloc_amount] [float] NOT NULL,
	[alloc_units] [float] NOT NULL,
	[audit_detail_num] [int] NOT NULL,
	[batch_id] [char](10) NOT NULL,
	[bill_post_sw] [char](1) NOT NULL,
	[credit_cpnyId] [char](10) NOT NULL,
	[credit_gl_acct] [char](10) NOT NULL,
	[credit_gl_subacct] [char](24) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[cury_alloc_amount] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CURYRATE] [float] NOT NULL,
	[curyratetype] [char](6) NOT NULL,
	[data1] [char](10) NOT NULL,
	[data2] [char](30) NOT NULL,
	[data3] [char](10) NOT NULL,
	[data4] [char](4) NOT NULL,
	[debit_cpnyId] [char](10) NOT NULL,
	[debit_gl_acct] [char](10) NOT NULL,
	[debit_gl_subacct] [char](24) NOT NULL,
	[detail_num] [int] NOT NULL,
	[emp_detail_flag] [char](1) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[gl_tran_info] [char](1) NOT NULL,
	[subacct_detail_flag] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[offset_acct] [char](16) NOT NULL,
	[offset_pjt_entity] [char](32) NOT NULL,
	[offset_project] [char](16) NOT NULL,
	[post_acct] [char](16) NOT NULL,
	[post_pjt_entity] [char](32) NOT NULL,
	[post_project] [char](16) NOT NULL,
	[recalc_flag] [char](1) NOT NULL,
	[system_cd] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjallaud0] PRIMARY KEY CLUSTERED 
(
	[fiscalno] ASC,
	[system_cd] ASC,
	[batch_id] ASC,
	[detail_num] ASC,
	[audit_detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
