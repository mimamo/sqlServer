USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJTranWk]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTranWk](
	[acct] [char](16) NOT NULL,
	[alloc_flag] [char](1) NOT NULL,
	[amount] [float] NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[batch_id] [char](10) NOT NULL,
	[batch_type] [char](4) NOT NULL,
	[bill_batch_id] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTranamt] [float] NOT NULL,
	[data1] [char](16) NOT NULL,
	[detail_num] [int] NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[post_date] [smalldatetime] NOT NULL,
	[project] [char](16) NOT NULL,
	[Subcontract] [char](16) NOT NULL,
	[system_cd] [char](2) NOT NULL,
	[trans_date] [smalldatetime] NOT NULL,
	[tr_comment] [char](100) NOT NULL,
	[tr_id01] [char](30) NOT NULL,
	[tr_id02] [char](30) NOT NULL,
	[tr_id03] [char](16) NOT NULL,
	[tr_id04] [char](16) NOT NULL,
	[tr_id05] [char](4) NOT NULL,
	[tr_id06] [float] NOT NULL,
	[tr_id07] [float] NOT NULL,
	[tr_id08] [smalldatetime] NOT NULL,
	[tr_id09] [smalldatetime] NOT NULL,
	[tr_id10] [int] NOT NULL,
	[tr_id23] [char](30) NOT NULL,
	[tr_id24] [char](20) NOT NULL,
	[tr_id25] [char](20) NOT NULL,
	[tr_id26] [char](10) NOT NULL,
	[tr_id27] [char](4) NOT NULL,
	[tr_id28] [float] NOT NULL,
	[tr_id29] [smalldatetime] NOT NULL,
	[tr_id30] [int] NOT NULL,
	[tr_id31] [float] NOT NULL,
	[tr_id32] [float] NOT NULL,
	[tr_status] [char](10) NOT NULL,
	[unit_of_measure] [char](10) NOT NULL,
	[units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[vendor_num] [char](15) NOT NULL,
	[voucher_line] [int] NOT NULL,
	[voucher_num] [char](10) NOT NULL,
	[alloc_batch] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtranwk0] PRIMARY KEY CLUSTERED 
(
	[alloc_batch] ASC,
	[fiscalno] ASC,
	[system_cd] ASC,
	[batch_id] ASC,
	[project] ASC,
	[detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
