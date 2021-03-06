USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PJUTTYPE]    Script Date: 12/21/2015 14:05:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJUTTYPE](
	[available] [char](1) NOT NULL,
	[column_nbr] [smallint] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[direct] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[ut_id01] [char](30) NOT NULL,
	[ut_id02] [char](30) NOT NULL,
	[ut_id03] [char](20) NOT NULL,
	[ut_id04] [char](20) NOT NULL,
	[ut_id05] [char](10) NOT NULL,
	[ut_id06] [char](10) NOT NULL,
	[ut_id07] [char](4) NOT NULL,
	[ut_id08] [float] NOT NULL,
	[ut_id09] [smalldatetime] NOT NULL,
	[ut_id10] [int] NOT NULL,
	[utilization_desc] [char](30) NOT NULL,
	[utilization_type] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjuttype0] PRIMARY KEY CLUSTERED 
(
	[utilization_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
