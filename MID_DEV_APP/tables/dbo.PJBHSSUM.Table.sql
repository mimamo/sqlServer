USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJBHSSUM]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBHSSUM](
	[acct] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](16) NOT NULL,
	[data2] [float] NOT NULL,
	[data3] [float] NOT NULL,
	[data4] [float] NOT NULL,
	[data5] [float] NOT NULL,
	[eac_amount] [float] NOT NULL,
	[eac_units] [float] NOT NULL,
	[fac_amount] [float] NOT NULL,
	[fac_units] [float] NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[total_budget_amount] [float] NOT NULL,
	[total_budget_units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PJBHSSUM0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[pjt_entity] ASC,
	[acct] ASC,
	[fiscalno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
