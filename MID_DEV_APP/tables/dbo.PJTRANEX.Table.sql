USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJTRANEX]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTRANEX](
	[batch_id] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[detail_num] [int] NOT NULL,
	[equip_id] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[invtid] [char](30) NOT NULL,
	[lotsernbr] [char](25) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[siteid] [char](10) NOT NULL,
	[system_cd] [char](2) NOT NULL,
	[tr_id11] [char](30) NOT NULL,
	[tr_id12] [char](30) NOT NULL,
	[tr_id13] [char](30) NOT NULL,
	[tr_id14] [char](16) NOT NULL,
	[tr_id15] [char](16) NOT NULL,
	[tr_id16] [char](16) NOT NULL,
	[tr_id17] [char](4) NOT NULL,
	[tr_id18] [char](4) NOT NULL,
	[tr_id19] [char](4) NOT NULL,
	[tr_id20] [char](40) NOT NULL,
	[tr_id21] [char](40) NOT NULL,
	[tr_id22] [smalldatetime] NOT NULL,
	[tr_status2] [char](1) NOT NULL,
	[tr_status3] [char](1) NOT NULL,
	[whseloc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtranex0] PRIMARY KEY CLUSTERED 
(
	[fiscalno] ASC,
	[system_cd] ASC,
	[batch_id] ASC,
	[detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
