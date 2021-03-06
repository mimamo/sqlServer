USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJUOPDET]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJUOPDET](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[percent_comp] [float] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[prod_units] [float] NOT NULL,
	[prod_uom] [char](6) NOT NULL,
	[project] [char](16) NOT NULL,
	[up_date] [smalldatetime] NOT NULL,
	[up_id01] [char](30) NOT NULL,
	[up_id02] [char](30) NOT NULL,
	[up_id03] [char](20) NOT NULL,
	[up_id04] [char](20) NOT NULL,
	[up_id05] [char](10) NOT NULL,
	[up_id06] [char](10) NOT NULL,
	[up_id07] [char](4) NOT NULL,
	[up_id08] [float] NOT NULL,
	[up_id09] [smalldatetime] NOT NULL,
	[up_id10] [int] NOT NULL,
	[up_id11] [char](30) NOT NULL,
	[up_id12] [char](30) NOT NULL,
	[up_id13] [char](20) NOT NULL,
	[up_id14] [char](20) NOT NULL,
	[up_id15] [char](10) NOT NULL,
	[up_id16] [char](10) NOT NULL,
	[up_id17] [char](4) NOT NULL,
	[up_id18] [float] NOT NULL,
	[up_id19] [smalldatetime] NOT NULL,
	[up_id20] [int] NOT NULL,
	[up_status] [char](1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjuopdet0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC,
	[linenbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
