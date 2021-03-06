USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xIGProdCode]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xIGProdCode](
	[activate_by] [char](16) NOT NULL,
	[activate_date] [smalldatetime] NOT NULL,
	[code_group] [char](30) NOT NULL,
	[code_ID] [char](4) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[deactivate_by] [char](16) NOT NULL,
	[deactivate_date] [smalldatetime] NOT NULL,
	[descr] [char](30) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[status] [char](1) NOT NULL,
	[Type] [char](1) NOT NULL,
	[user01] [char](30) NOT NULL,
	[user02] [char](30) NOT NULL,
	[user03] [float] NOT NULL,
	[user04] [float] NOT NULL,
	[user05] [char](10) NOT NULL,
	[user06] [char](10) NOT NULL,
	[user07] [smalldatetime] NOT NULL,
	[user08] [smalldatetime] NOT NULL,
	[user09] [smallint] NOT NULL,
	[user10] [smallint] NOT NULL,
	[user11] [char](2) NOT NULL,
	[user12] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
