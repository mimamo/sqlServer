USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJREVTSK]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJREVTSK](
	[contract_type] [char](4) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[fips_num] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[manager1] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[pe_id01] [char](30) NOT NULL,
	[pe_id02] [char](30) NOT NULL,
	[pe_id03] [char](16) NOT NULL,
	[pe_id04] [char](16) NOT NULL,
	[pe_id05] [char](4) NOT NULL,
	[pe_id06] [float] NOT NULL,
	[pe_id07] [float] NOT NULL,
	[pe_id08] [smalldatetime] NOT NULL,
	[pe_id09] [smalldatetime] NOT NULL,
	[pe_id10] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[pjt_entity_desc] [char](60) NOT NULL,
	[project] [char](16) NOT NULL,
	[revid] [char](4) NOT NULL,
	[rt_id01] [char](30) NOT NULL,
	[rt_id02] [char](30) NOT NULL,
	[rt_id03] [char](16) NOT NULL,
	[rt_id04] [char](16) NOT NULL,
	[rt_id05] [char](4) NOT NULL,
	[rt_id06] [float] NOT NULL,
	[rt_id07] [float] NOT NULL,
	[rt_id08] [smalldatetime] NOT NULL,
	[rt_id09] [smalldatetime] NOT NULL,
	[rt_id10] [int] NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrevtsk0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[revid] ASC,
	[pjt_entity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
