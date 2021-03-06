USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PJFISCAL]    Script Date: 12/21/2015 14:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJFISCAL](
	[comment] [char](30) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](30) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[factor] [float] NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjfiscal0] PRIMARY KEY CLUSTERED 
(
	[fiscalno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
