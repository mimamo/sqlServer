USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJCOMMUN]    Script Date: 12/21/2015 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCOMMUN](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[destination] [char](50) NOT NULL,
	[destination_type] [char](1) NOT NULL,
	[email_address] [char](100) NOT NULL,
	[exe_caption1] [char](30) NOT NULL,
	[exe_caption2] [char](30) NOT NULL,
	[exe_caption3] [char](30) NOT NULL,
	[exe_name1] [char](100) NOT NULL,
	[exe_name2] [char](100) NOT NULL,
	[exe_name3] [char](100) NOT NULL,
	[exe_parm1] [char](100) NOT NULL,
	[exe_parm2] [char](100) NOT NULL,
	[exe_parm3] [char](100) NOT NULL,
	[exe_type1] [char](1) NOT NULL,
	[exe_type2] [char](1) NOT NULL,
	[exe_type3] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[mail_flag] [char](1) NOT NULL,
	[msg_key] [char](48) NOT NULL,
	[msg_status] [char](1) NOT NULL,
	[msg_suffix] [char](2) NOT NULL,
	[msg_text] [char](254) NOT NULL,
	[msg_type] [char](6) NOT NULL,
	[sender] [char](50) NOT NULL,
	[source_function] [char](30) NOT NULL,
	[subject] [char](50) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjcommun0] PRIMARY KEY CLUSTERED 
(
	[msg_type] ASC,
	[msg_key] ASC,
	[msg_suffix] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
