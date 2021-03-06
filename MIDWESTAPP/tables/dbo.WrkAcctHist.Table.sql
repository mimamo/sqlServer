USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[WrkAcctHist]    Script Date: 12/21/2015 15:54:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkAcctHist](
	[Acct] [char](10) NOT NULL,
	[begbal] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[fiscyr] [char](4) NOT NULL,
	[LastClosePerNbr] [char](6) NOT NULL,
	[LedgerID] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PtdBal00] [float] NOT NULL,
	[PtdBal01] [float] NOT NULL,
	[PtdBal02] [float] NOT NULL,
	[PtdBal03] [float] NOT NULL,
	[PtdBal04] [float] NOT NULL,
	[PtdBal05] [float] NOT NULL,
	[PtdBal06] [float] NOT NULL,
	[PtdBal07] [float] NOT NULL,
	[PtdBal08] [float] NOT NULL,
	[PtdBal09] [float] NOT NULL,
	[PtdBal10] [float] NOT NULL,
	[PtdBal11] [float] NOT NULL,
	[PtdBal12] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[YtdBal00] [float] NOT NULL,
	[YtdBal01] [float] NOT NULL,
	[YtdBal02] [float] NOT NULL,
	[YtdBal03] [float] NOT NULL,
	[YtdBal04] [float] NOT NULL,
	[YtdBal05] [float] NOT NULL,
	[YtdBal06] [float] NOT NULL,
	[YtdBal07] [float] NOT NULL,
	[YtdBal08] [float] NOT NULL,
	[YtdBal09] [float] NOT NULL,
	[YtdBal10] [float] NOT NULL,
	[YtdBal11] [float] NOT NULL,
	[YtdBal12] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkAcctHist0] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[CpnyID] ASC,
	[Acct] ASC,
	[Sub] ASC,
	[LedgerID] ASC,
	[fiscyr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
