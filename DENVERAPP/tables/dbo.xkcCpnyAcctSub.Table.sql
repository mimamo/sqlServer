USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xkcCpnyAcctSub]    Script Date: 12/21/2015 15:42:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xkcCpnyAcctSub](
	[xfromacct] [char](10) NULL,
	[xfromsub] [char](24) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[xtoacct] [char](10) NULL,
	[xtosub] [char](24) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
