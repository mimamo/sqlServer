USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJINVSEC]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJINVSEC](
	[acct] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[desc_print_sw] [char](1) NOT NULL,
	[inv_format_cd] [char](4) NOT NULL,
	[is_id01] [char](30) NOT NULL,
	[is_id02] [char](16) NOT NULL,
	[is_id03] [char](4) NOT NULL,
	[is_id04] [char](4) NOT NULL,
	[is_id05] [char](4) NOT NULL,
	[is_id06] [char](4) NOT NULL,
	[is_id07] [char](1) NOT NULL,
	[is_id08] [char](1) NOT NULL,
	[is_id09] [char](1) NOT NULL,
	[is_id10] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[section_desc] [char](40) NOT NULL,
	[section_num] [char](4) NOT NULL,
	[section_type] [char](30) NOT NULL,
	[subtotal_sw] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjinvsec0] PRIMARY KEY CLUSTERED 
(
	[inv_format_cd] ASC,
	[section_num] ASC,
	[acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
