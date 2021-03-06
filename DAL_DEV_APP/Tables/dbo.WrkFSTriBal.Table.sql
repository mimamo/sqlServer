USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkFSTriBal]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkFSTriBal](
	[Acct] [char](10) NOT NULL,
	[AcctType] [char](2) NOT NULL,
	[AdjgCrAmt] [float] NOT NULL,
	[AdjgDrAmt] [float] NOT NULL,
	[BegBal] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[EndBal] [float] NOT NULL,
	[PtdBal] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
