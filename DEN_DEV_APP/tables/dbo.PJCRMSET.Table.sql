USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PJCRMSET]    Script Date: 12/21/2015 14:05:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCRMSET](
	[BegPer00] [smallint] NOT NULL,
	[BegPer01] [smallint] NOT NULL,
	[BegPer02] [smallint] NOT NULL,
	[BegPer03] [smallint] NOT NULL,
	[BegPer04] [smallint] NOT NULL,
	[BegPer05] [smallint] NOT NULL,
	[CalcCapacity] [char](1) NOT NULL,
	[CalcMethod] [char](1) NOT NULL,
	[CloseProbability] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](16) NOT NULL,
	[data2] [smallint] NOT NULL,
	[data3] [float] NOT NULL,
	[DurationDays] [int] NOT NULL,
	[EndPer00] [smallint] NOT NULL,
	[EndPer01] [smallint] NOT NULL,
	[EndPer02] [smallint] NOT NULL,
	[EndPer03] [smallint] NOT NULL,
	[EndPer04] [smallint] NOT NULL,
	[EndPer05] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[PerPercentage00] [float] NOT NULL,
	[PerPercentage01] [float] NOT NULL,
	[PerPercentage02] [float] NOT NULL,
	[PerPercentage03] [float] NOT NULL,
	[PerPercentage04] [float] NOT NULL,
	[PerPercentage05] [float] NOT NULL,
	[SetupID] [smallint] NOT NULL,
	[TimePhaseThreshold] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[Weight] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PJCRMSET0] PRIMARY KEY CLUSTERED 
(
	[SetupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
