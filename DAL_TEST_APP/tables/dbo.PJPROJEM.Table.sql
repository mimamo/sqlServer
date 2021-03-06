USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPROJEM]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPROJEM](
	[access_data1] [char](1) NOT NULL,
	[access_data2] [char](32) NOT NULL,
	[access_insert] [char](1) NOT NULL,
	[access_update] [char](1) NOT NULL,
	[access_view] [char](1) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[pv_id01] [char](32) NOT NULL,
	[pv_id02] [char](32) NOT NULL,
	[pv_id03] [char](16) NOT NULL,
	[pv_id04] [char](16) NOT NULL,
	[pv_id05] [char](4) NOT NULL,
	[pv_id06] [float] NOT NULL,
	[pv_id07] [float] NOT NULL,
	[pv_id08] [smalldatetime] NOT NULL,
	[pv_id09] [smalldatetime] NOT NULL,
	[pv_id10] [int] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjprojem0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[employee] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
