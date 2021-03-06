USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJSUBVEN]    Script Date: 12/21/2015 13:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJSUBVEN](
	[carrier1] [char](20) NOT NULL,
	[carrier2] [char](20) NOT NULL,
	[carrier3] [char](20) NOT NULL,
	[carrier4] [char](20) NOT NULL,
	[carrier5] [char](20) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[date_ins_eff1] [smalldatetime] NOT NULL,
	[date_ins_eff2] [smalldatetime] NOT NULL,
	[date_ins_eff3] [smalldatetime] NOT NULL,
	[date_ins_eff4] [smalldatetime] NOT NULL,
	[date_ins_eff5] [smalldatetime] NOT NULL,
	[date_ins_exp1] [smalldatetime] NOT NULL,
	[date_ins_exp2] [smalldatetime] NOT NULL,
	[date_ins_exp3] [smalldatetime] NOT NULL,
	[date_ins_exp4] [smalldatetime] NOT NULL,
	[date_ins_exp5] [smalldatetime] NOT NULL,
	[eeo_class_cd] [char](4) NOT NULL,
	[flag_disabled] [char](1) NOT NULL,
	[flag_female] [char](1) NOT NULL,
	[flag_minority] [char](1) NOT NULL,
	[flag_preferred] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pay_control] [char](2) NOT NULL,
	[policy_amt1] [float] NOT NULL,
	[policy_amt2] [float] NOT NULL,
	[policy_amt3] [float] NOT NULL,
	[policy_amt4] [float] NOT NULL,
	[policy_amt5] [float] NOT NULL,
	[policy_nbr1] [char](20) NOT NULL,
	[policy_nbr2] [char](20) NOT NULL,
	[policy_nbr3] [char](20) NOT NULL,
	[policy_nbr4] [char](20) NOT NULL,
	[policy_nbr5] [char](20) NOT NULL,
	[policy_type_cd1] [char](2) NOT NULL,
	[policy_type_cd2] [char](2) NOT NULL,
	[policy_type_cd3] [char](2) NOT NULL,
	[policy_type_cd4] [char](2) NOT NULL,
	[policy_type_cd5] [char](2) NOT NULL,
	[specialty_cd] [char](4) NOT NULL,
	[status] [char](1) NOT NULL,
	[sv_id01] [char](30) NOT NULL,
	[sv_id02] [char](30) NOT NULL,
	[sv_id03] [char](16) NOT NULL,
	[sv_id04] [char](16) NOT NULL,
	[sv_id05] [char](4) NOT NULL,
	[sv_id06] [float] NOT NULL,
	[sv_id07] [float] NOT NULL,
	[sv_id08] [smalldatetime] NOT NULL,
	[sv_id09] [smalldatetime] NOT NULL,
	[sv_id10] [int] NOT NULL,
	[sv_id11] [char](30) NOT NULL,
	[sv_id12] [char](30) NOT NULL,
	[sv_id13] [char](16) NOT NULL,
	[sv_id14] [char](16) NOT NULL,
	[sv_id15] [char](4) NOT NULL,
	[sv_id16] [float] NOT NULL,
	[sv_id17] [float] NOT NULL,
	[sv_id18] [smalldatetime] NOT NULL,
	[sv_id19] [smalldatetime] NOT NULL,
	[sv_id20] [int] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[vend_name] [char](60) NOT NULL,
	[vendid] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjsubven0] PRIMARY KEY CLUSTERED 
(
	[vendid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
