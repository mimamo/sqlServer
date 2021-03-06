USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkDefExpt]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkDefExpt](
	[Acct] [char](10) NOT NULL,
	[Active] [smallint] NOT NULL,
	[AcctType] [char](2) NOT NULL,
	[DstCuryID] [char](4) NOT NULL,
	[DstLedgerID] [char](10) NOT NULL,
	[PTDBal] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SrcCuryID] [char](4) NOT NULL,
	[SrcLedgerID] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TrslID] [char](10) NOT NULL,
	[TrslDesc] [char](30) NOT NULL,
	[YTDBal] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
