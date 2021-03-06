USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJALERT]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJALERT](
	[alert_group_cd] [char](4) NOT NULL,
	[alert_id] [smallint] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](20) NOT NULL,
	[data2] [char](30) NOT NULL,
	[data3] [float] NOT NULL,
	[employee] [char](10) NOT NULL,
	[event_id] [char](8) NOT NULL,
	[last_eval_date] [smalldatetime] NOT NULL,
	[last_eval_time] [smalldatetime] NOT NULL,
	[levelnbr] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[mgr_type] [char](2) NOT NULL,
	[noteid] [int] NOT NULL,
	[param1] [float] NOT NULL,
	[param2] [float] NOT NULL,
	[param3] [float] NOT NULL,
	[select_item1] [char](40) NOT NULL,
	[select_item2] [char](40) NOT NULL,
	[select_item3] [char](40) NOT NULL,
	[select_sw] [char](1) NOT NULL,
	[select_value1] [char](30) NOT NULL,
	[select_value2] [char](30) NOT NULL,
	[select_value3] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjalert0] PRIMARY KEY CLUSTERED 
(
	[alert_group_cd] ASC,
	[alert_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
