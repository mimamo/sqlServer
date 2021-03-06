USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJCONT]    Script Date: 12/21/2015 14:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCONT](
	[change_days] [smallint] NOT NULL,
	[change_flag] [char](1) NOT NULL,
	[contract] [char](16) NOT NULL,
	[contract_desc] [char](60) NOT NULL,
	[cn_id01] [char](30) NOT NULL,
	[cn_id02] [char](30) NOT NULL,
	[cn_id03] [char](16) NOT NULL,
	[cn_id04] [char](16) NOT NULL,
	[cn_id05] [char](4) NOT NULL,
	[cn_id06] [float] NOT NULL,
	[cn_id07] [float] NOT NULL,
	[cn_id08] [smalldatetime] NOT NULL,
	[cn_id09] [smalldatetime] NOT NULL,
	[cn_id10] [int] NOT NULL,
	[cn_id11] [char](30) NOT NULL,
	[cn_id12] [char](30) NOT NULL,
	[cn_id13] [char](16) NOT NULL,
	[cn_id14] [char](16) NOT NULL,
	[cn_id15] [char](4) NOT NULL,
	[cn_id16] [float] NOT NULL,
	[cn_id17] [float] NOT NULL,
	[cn_id18] [smalldatetime] NOT NULL,
	[cn_id19] [smalldatetime] NOT NULL,
	[cn_id20] [int] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[cust_ref] [char](30) NOT NULL,
	[customer] [char](15) NOT NULL,
	[date_comp_act] [smalldatetime] NOT NULL,
	[date_comp_ant] [smalldatetime] NOT NULL,
	[date_cont_exe] [smalldatetime] NOT NULL,
	[date_start_act] [smalldatetime] NOT NULL,
	[date_start_ant] [smalldatetime] NOT NULL,
	[date_start_auth] [smalldatetime] NOT NULL,
	[date_start_org] [smalldatetime] NOT NULL,
	[date_end_org] [smalldatetime] NOT NULL,
	[date_end_rev] [smalldatetime] NOT NULL,
	[extension_days] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[manager_acct] [char](10) NOT NULL,
	[manager_cont] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[prime_type_cd] [char](4) NOT NULL,
	[status1] [char](1) NOT NULL,
	[termsid] [char](2) NOT NULL,
	[text_contract1] [char](254) NOT NULL,
	[text_contract2] [char](254) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjcont0] PRIMARY KEY CLUSTERED 
(
	[contract] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
