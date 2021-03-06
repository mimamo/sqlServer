USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PJEQRATE]    Script Date: 12/21/2015 16:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEQRATE](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[ec_id01] [char](30) NOT NULL,
	[ec_id02] [char](30) NOT NULL,
	[ec_id03] [char](16) NOT NULL,
	[ec_id04] [char](16) NOT NULL,
	[ec_id05] [char](4) NOT NULL,
	[ec_id06] [float] NOT NULL,
	[ec_id07] [float] NOT NULL,
	[ec_id08] [smalldatetime] NOT NULL,
	[ec_id09] [smalldatetime] NOT NULL,
	[ec_id10] [int] NOT NULL,
	[ec_id11] [char](30) NOT NULL,
	[ec_id12] [char](30) NOT NULL,
	[ec_id13] [char](16) NOT NULL,
	[ec_id14] [char](16) NOT NULL,
	[ec_id15] [char](4) NOT NULL,
	[ec_id16] [float] NOT NULL,
	[ec_id17] [float] NOT NULL,
	[ec_id18] [smalldatetime] NOT NULL,
	[ec_id19] [smalldatetime] NOT NULL,
	[ec_id20] [int] NOT NULL,
	[effect_date] [smalldatetime] NOT NULL,
	[equip_id] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[rate1] [float] NOT NULL,
	[rate2] [float] NOT NULL,
	[rate3] [float] NOT NULL,
	[unit_of_measure] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjeqrate0] PRIMARY KEY CLUSTERED 
(
	[equip_id] ASC,
	[project] ASC,
	[effect_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
