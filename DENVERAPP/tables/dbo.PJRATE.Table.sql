USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PJRATE]    Script Date: 12/21/2015 15:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRATE](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[curyid] [char](4) NOT NULL,
	[data1] [char](16) NOT NULL,
	[data2] [float] NOT NULL,
	[effect_date] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[rate] [float] NOT NULL,
	[rate_key_value1] [char](32) NOT NULL,
	[rate_key_value2] [char](32) NOT NULL,
	[rate_key_value3] [char](32) NOT NULL,
	[rate_level] [char](1) NOT NULL,
	[rate_table_id] [char](4) NOT NULL,
	[rate_type_cd] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrate0] PRIMARY KEY CLUSTERED 
(
	[rate_table_id] ASC,
	[rate_type_cd] ASC,
	[rate_level] ASC,
	[rate_key_value1] ASC,
	[rate_key_value2] ASC,
	[rate_key_value3] ASC,
	[effect_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
