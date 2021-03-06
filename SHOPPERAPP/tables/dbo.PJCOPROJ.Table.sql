USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJCOPROJ]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCOPROJ](
	[amt_funded] [float] NOT NULL,
	[amt_original] [float] NOT NULL,
	[amt_pending] [float] NOT NULL,
	[amt_quote] [float] NOT NULL,
	[amt_revenue] [float] NOT NULL,
	[apprv_arch_by] [char](20) NOT NULL,
	[apprv_arch_date] [smalldatetime] NOT NULL,
	[apprv_arch_for] [char](20) NOT NULL,
	[apprv_cont_by] [char](20) NOT NULL,
	[apprv_cont_date] [smalldatetime] NOT NULL,
	[apprv_cont_for] [char](20) NOT NULL,
	[apprv_othr_by] [char](20) NOT NULL,
	[apprv_othr_date] [smalldatetime] NOT NULL,
	[apprv_othr_for] [char](20) NOT NULL,
	[apprv_ownr_by] [char](20) NOT NULL,
	[apprv_ownr_date] [smalldatetime] NOT NULL,
	[apprv_ownr_for] [char](20) NOT NULL,
	[arch_pjt] [char](16) NOT NULL,
	[auth_by] [char](20) NOT NULL,
	[change_order_num] [char](16) NOT NULL,
	[co_approval_cd] [char](4) NOT NULL,
	[co_cat_cd] [char](4) NOT NULL,
	[co_desc] [char](60) NOT NULL,
	[co_id01] [char](30) NOT NULL,
	[co_id02] [char](30) NOT NULL,
	[co_id03] [char](16) NOT NULL,
	[co_id04] [char](16) NOT NULL,
	[co_id05] [char](4) NOT NULL,
	[co_id06] [float] NOT NULL,
	[co_id07] [float] NOT NULL,
	[co_id08] [smalldatetime] NOT NULL,
	[co_id09] [smalldatetime] NOT NULL,
	[co_id10] [int] NOT NULL,
	[co_id11] [char](30) NOT NULL,
	[co_id12] [char](30) NOT NULL,
	[co_id13] [char](16) NOT NULL,
	[co_id14] [char](16) NOT NULL,
	[co_id15] [char](4) NOT NULL,
	[co_id16] [float] NOT NULL,
	[co_id17] [float] NOT NULL,
	[co_id18] [smalldatetime] NOT NULL,
	[co_id19] [smalldatetime] NOT NULL,
	[co_id20] [int] NOT NULL,
	[co_type] [char](2) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[date_auth] [smalldatetime] NOT NULL,
	[date_co] [smalldatetime] NOT NULL,
	[fund_source] [char](20) NOT NULL,
	[impact_days_apprv] [smallint] NOT NULL,
	[impact_days_reqd] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[owner_co] [char](16) NOT NULL,
	[owner_ref] [char](16) NOT NULL,
	[probability] [smallint] NOT NULL,
	[project] [char](16) NOT NULL,
	[reqd_by] [char](20) NOT NULL,
	[reqd_reason] [char](30) NOT NULL,
	[status1] [char](1) NOT NULL,
	[status2] [char](1) NOT NULL,
	[text_sub1] [char](254) NOT NULL,
	[text_sub2] [char](254) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjcoproj0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[change_order_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
