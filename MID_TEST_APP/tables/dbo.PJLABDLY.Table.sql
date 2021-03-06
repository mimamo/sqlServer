USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJLABDLY]    Script Date: 12/21/2015 14:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJLABDLY](
	[certprflag] [smallint] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [float] NOT NULL,
	[data2] [float] NOT NULL,
	[data3] [char](254) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[error] [char](1) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[groupcode] [char](10) NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[ldl_date] [smalldatetime] NOT NULL,
	[ldl_day] [char](4) NOT NULL,
	[ldl_desc] [char](30) NOT NULL,
	[ldl_edtime] [char](4) NOT NULL,
	[ldl_elptime] [char](4) NOT NULL,
	[ldl_siteid] [char](4) NOT NULL,
	[ldl_sttime] [char](4) NOT NULL,
	[ldl_wdhours] [float] NOT NULL,
	[ly_id01] [char](30) NOT NULL,
	[ly_id02] [char](30) NOT NULL,
	[ly_id03] [char](16) NOT NULL,
	[ly_id04] [char](16) NOT NULL,
	[ly_id05] [char](4) NOT NULL,
	[ly_id06] [float] NOT NULL,
	[ly_id07] [float] NOT NULL,
	[ly_id08] [smalldatetime] NOT NULL,
	[ly_id09] [smalldatetime] NOT NULL,
	[ly_id10] [int] NOT NULL,
	[lineNbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[ovt1_wdhours] [float] NOT NULL,
	[ovt2_wdhours] [float] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[WorkType] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjlabdly0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC,
	[ldl_siteid] ASC,
	[lineNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
