USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PJPOOLH]    Script Date: 12/21/2015 14:05:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPOOLH](
	[allocmthd] [char](2) NOT NULL,
	[alloc_sequence] [int] NOT NULL,
	[cpnyid] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[grpid] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[period] [char](6) NOT NULL,
	[ph_id01] [char](30) NOT NULL,
	[ph_id02] [char](16) NOT NULL,
	[ph_id03] [float] NOT NULL,
	[ph_id04] [float] NOT NULL,
	[ph_id05] [smalldatetime] NOT NULL,
	[ph_id06] [int] NOT NULL,
	[rate_ptd] [float] NOT NULL,
	[rate_ytd] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpoolh0] PRIMARY KEY CLUSTERED 
(
	[grpid] ASC,
	[period] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
