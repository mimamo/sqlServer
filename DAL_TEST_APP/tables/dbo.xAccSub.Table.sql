USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xAccSub]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAccSub](
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
