USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkCAForecast]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkCAForecast](
	[Bankacct] [char](10) NOT NULL,
	[Banksub] [char](24) NOT NULL,
	[cpnyid] [char](10) NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[Module] [char](2) NOT NULL,
	[Period1Amt] [float] NOT NULL,
	[Period1Curyamt] [float] NOT NULL,
	[Period1Date] [smalldatetime] NOT NULL,
	[Period2Amt] [float] NOT NULL,
	[Period2CuryAmt] [float] NOT NULL,
	[Period2Date] [smalldatetime] NOT NULL,
	[Period3Amt] [float] NOT NULL,
	[Period3CuryAmt] [float] NOT NULL,
	[Period3Date] [smalldatetime] NOT NULL,
	[Period4Amt] [float] NOT NULL,
	[Period4CuryAmt] [float] NOT NULL,
	[Period4Date] [smalldatetime] NOT NULL,
	[Period5Amt] [float] NOT NULL,
	[Period5CuryAmt] [float] NOT NULL,
	[Period5date] [smalldatetime] NOT NULL,
	[Period6Amt] [float] NOT NULL,
	[Period6CuryAmt] [float] NOT NULL,
	[Period6date] [smalldatetime] NOT NULL,
	[Period7Amt] [float] NOT NULL,
	[Period7CuryAmt] [float] NOT NULL,
	[Period7date] [smalldatetime] NOT NULL,
	[Period8Amt] [float] NOT NULL,
	[Period8CuryAmt] [float] NOT NULL,
	[Period8date] [smalldatetime] NOT NULL,
	[rcptDisbFlg] [char](1) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
