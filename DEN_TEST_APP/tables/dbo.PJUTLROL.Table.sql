USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PJUTLROL]    Script Date: 12/21/2015 14:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJUTLROL](
	[adjustments] [float] NOT NULL,
	[cost] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](16) NOT NULL,
	[data2] [float] NOT NULL,
	[data3] [float] NOT NULL,
	[data4] [float] NOT NULL,
	[data5] [float] NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[rate] [float] NOT NULL,
	[revenue] [float] NOT NULL,
	[units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[utilization_type] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjutlrol0] PRIMARY KEY CLUSTERED 
(
	[employee] ASC,
	[fiscalno] ASC,
	[utilization_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
