USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[frl_acct_code]    Script Date: 12/21/2015 14:05:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[frl_acct_code](
	[entity_num] [smallint] NOT NULL,
	[acct_code] [char](64) NOT NULL,
	[acct_status] [tinyint] NOT NULL,
	[acct_desc] [char](60) NOT NULL,
	[normal_bal] [tinyint] NOT NULL,
	[acct_group] [smallint] NOT NULL,
	[nat_seg_code] [char](64) NULL,
	[cpnyid] [char](10) NOT NULL,
	[acct] [char](10) NOT NULL,
	[sub] [char](24) NOT NULL,
	[seg01_code] [char](24) NULL,
	[seg02_code] [char](24) NULL,
	[seg03_code] [char](24) NULL,
	[seg04_code] [char](24) NULL,
	[seg05_code] [char](24) NULL,
	[seg06_code] [char](24) NULL,
	[seg07_code] [char](24) NULL,
	[seg08_code] [char](24) NULL,
	[seg09_code] [char](24) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
