USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PJRULEX]    Script Date: 12/21/2015 14:33:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRULEX](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[line_num] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[project] [char](16) NOT NULL,
	[rx_id01] [char](30) NOT NULL,
	[rx_id02] [char](16) NOT NULL,
	[rx_id03] [char](4) NOT NULL,
	[rx_id04] [char](4) NOT NULL,
	[rx_id05] [char](4) NOT NULL,
	[select_item1] [char](40) NOT NULL,
	[select_item2] [char](40) NOT NULL,
	[select_item3] [char](40) NOT NULL,
	[select_value1] [char](30) NOT NULL,
	[select_value2] [char](30) NOT NULL,
	[select_value3] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrulex0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[line_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
