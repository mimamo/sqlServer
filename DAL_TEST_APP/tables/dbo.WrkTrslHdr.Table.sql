USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkTrslHdr]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkTrslHdr](
	[CurPerEffDate] [smalldatetime] NOT NULL,
	[CurrAvgRate] [float] NOT NULL,
	[CurrBSRate] [float] NOT NULL,
	[DstCuryID] [char](4) NOT NULL,
	[DstLedgerID] [char](10) NOT NULL,
	[Period] [char](6) NOT NULL,
	[PriorBSRate] [float] NOT NULL,
	[PriorPerEffDate] [smalldatetime] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SrcCuryID] [char](4) NOT NULL,
	[SrcLedgerID] [char](10) NOT NULL,
	[TrslId] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkTrslHdr0] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[TrslId] ASC,
	[Period] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
