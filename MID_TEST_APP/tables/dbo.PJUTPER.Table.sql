USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJUTPER]    Script Date: 12/21/2015 14:26:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJUTPER](
	[comment] [char](30) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[period] [char](6) NOT NULL,
	[pu_id01] [char](30) NOT NULL,
	[pu_id02] [char](30) NOT NULL,
	[pu_id03] [char](20) NOT NULL,
	[pu_id04] [char](20) NOT NULL,
	[pu_id05] [char](10) NOT NULL,
	[pu_id06] [char](10) NOT NULL,
	[pu_id07] [char](4) NOT NULL,
	[pu_id08] [float] NOT NULL,
	[pu_id09] [smalldatetime] NOT NULL,
	[pu_id10] [int] NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjutper0] PRIMARY KEY CLUSTERED 
(
	[period] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
