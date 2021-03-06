USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PJWAGEUN]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJWAGEUN](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[effect_date] [smalldatetime] NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[labor_rate] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[un_id01] [char](30) NOT NULL,
	[un_id02] [char](30) NOT NULL,
	[un_id03] [char](16) NOT NULL,
	[un_id04] [char](16) NOT NULL,
	[un_id05] [char](4) NOT NULL,
	[un_id06] [float] NOT NULL,
	[un_id07] [float] NOT NULL,
	[un_id08] [smalldatetime] NOT NULL,
	[un_id09] [smalldatetime] NOT NULL,
	[un_id10] [int] NOT NULL,
	[un_id11] [char](30) NOT NULL,
	[un_id12] [char](30) NOT NULL,
	[un_id13] [char](16) NOT NULL,
	[un_id14] [char](16) NOT NULL,
	[un_id15] [char](4) NOT NULL,
	[un_id16] [float] NOT NULL,
	[un_id17] [float] NOT NULL,
	[un_id18] [smalldatetime] NOT NULL,
	[un_id19] [smalldatetime] NOT NULL,
	[un_id20] [int] NOT NULL,
	[union_cd] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[work_type] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjwageun0] PRIMARY KEY CLUSTERED 
(
	[union_cd] ASC,
	[labor_class_cd] ASC,
	[work_type] ASC,
	[effect_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
