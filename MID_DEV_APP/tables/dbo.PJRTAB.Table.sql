USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJRTAB]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRTAB](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[l1_rate_key1_cd] [char](4) NOT NULL,
	[l1_rate_key2_cd] [char](4) NOT NULL,
	[l1_rate_key3_cd] [char](4) NOT NULL,
	[l2_rate_key1_cd] [char](4) NOT NULL,
	[l2_rate_key2_cd] [char](4) NOT NULL,
	[l2_rate_key3_cd] [char](4) NOT NULL,
	[l3_rate_key1_cd] [char](4) NOT NULL,
	[l3_rate_key2_cd] [char](4) NOT NULL,
	[l3_rate_key3_cd] [char](4) NOT NULL,
	[l4_rate_key1_cd] [char](4) NOT NULL,
	[l4_rate_key2_cd] [char](4) NOT NULL,
	[l4_rate_key3_cd] [char](4) NOT NULL,
	[l5_rate_key1_cd] [char](4) NOT NULL,
	[l5_rate_key2_cd] [char](4) NOT NULL,
	[l5_rate_key3_cd] [char](4) NOT NULL,
	[l6_rate_key1_cd] [char](4) NOT NULL,
	[l6_rate_key2_cd] [char](4) NOT NULL,
	[l6_rate_key3_cd] [char](4) NOT NULL,
	[l7_rate_key1_cd] [char](4) NOT NULL,
	[l7_rate_key2_cd] [char](4) NOT NULL,
	[l7_rate_key3_cd] [char](4) NOT NULL,
	[l8_rate_key1_cd] [char](4) NOT NULL,
	[l8_rate_key2_cd] [char](4) NOT NULL,
	[l8_rate_key3_cd] [char](4) NOT NULL,
	[l9_rate_key1_cd] [char](4) NOT NULL,
	[l9_rate_key2_cd] [char](4) NOT NULL,
	[l9_rate_key3_cd] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[rate_table_id] [char](4) NOT NULL,
	[rate_type_cd] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrtab0] PRIMARY KEY CLUSTERED 
(
	[rate_table_id] ASC,
	[rate_type_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
