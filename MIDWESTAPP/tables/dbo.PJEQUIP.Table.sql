USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PJEQUIP]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEQUIP](
	[cpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[eq_id01] [char](30) NOT NULL,
	[eq_id02] [char](30) NOT NULL,
	[eq_id03] [char](16) NOT NULL,
	[eq_id04] [char](16) NOT NULL,
	[eq_id05] [char](4) NOT NULL,
	[eq_id06] [float] NOT NULL,
	[eq_id07] [float] NOT NULL,
	[eq_id08] [smalldatetime] NOT NULL,
	[eq_id09] [smalldatetime] NOT NULL,
	[eq_id10] [int] NOT NULL,
	[eq_id11] [char](30) NOT NULL,
	[eq_id12] [char](30) NOT NULL,
	[eq_id13] [char](4) NOT NULL,
	[eq_id14] [char](4) NOT NULL,
	[eq_id15] [char](4) NOT NULL,
	[eq_id16] [char](4) NOT NULL,
	[eq_id17] [char](2) NOT NULL,
	[eq_id18] [char](2) NOT NULL,
	[eq_id19] [char](2) NOT NULL,
	[eq_id20] [char](2) NOT NULL,
	[er_id01] [char](30) NOT NULL,
	[er_id02] [char](30) NOT NULL,
	[er_id03] [char](16) NOT NULL,
	[er_id04] [char](16) NOT NULL,
	[er_id05] [char](4) NOT NULL,
	[er_id06] [float] NOT NULL,
	[er_id07] [float] NOT NULL,
	[er_id08] [smalldatetime] NOT NULL,
	[er_id09] [smalldatetime] NOT NULL,
	[er_id10] [smallint] NOT NULL,
	[equip_desc] [char](60) NOT NULL,
	[equip_id] [char](10) NOT NULL,
	[equip_type] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[project_costbasis] [char](16) NOT NULL,
	[status] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjequip0] PRIMARY KEY CLUSTERED 
(
	[equip_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
