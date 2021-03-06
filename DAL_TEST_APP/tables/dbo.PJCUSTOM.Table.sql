USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJCUSTOM]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCUSTOM](
	[applicationID] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[cu_id01] [char](30) NOT NULL,
	[cu_id02] [char](30) NOT NULL,
	[cu_id03] [char](16) NOT NULL,
	[cu_id04] [char](16) NOT NULL,
	[cu_id05] [char](4) NOT NULL,
	[cu_id06] [float] NOT NULL,
	[cu_id07] [float] NOT NULL,
	[cu_id08] [smalldatetime] NOT NULL,
	[cu_id09] [smalldatetime] NOT NULL,
	[cu_id10] [int] NOT NULL,
	[cu_id11] [char](30) NOT NULL,
	[cu_id12] [char](30) NOT NULL,
	[cu_id13] [char](20) NOT NULL,
	[cu_id14] [char](20) NOT NULL,
	[cu_id15] [char](10) NOT NULL,
	[cu_id16] [char](10) NOT NULL,
	[cu_id17] [char](4) NOT NULL,
	[cu_id18] [float] NOT NULL,
	[cu_id19] [float] NOT NULL,
	[cu_id20] [smalldatetime] NOT NULL,
	[defaultvalue] [char](30) NOT NULL,
	[defaulttype] [char](1) NOT NULL,
	[display] [bit] NOT NULL,
	[enable] [bit] NOT NULL,
	[fieldID] [char](10) NOT NULL,
	[fieldname] [char](30) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[label] [char](30) NOT NULL,
	[tab] [smallint] NOT NULL,
	[PV] [char](30) NOT NULL,
	[type] [char](4) NOT NULL,
	[sequenceval] [smallint] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[userid] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PJCUSTOM0] PRIMARY KEY CLUSTERED 
(
	[applicationID] ASC,
	[fieldID] ASC,
	[type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
