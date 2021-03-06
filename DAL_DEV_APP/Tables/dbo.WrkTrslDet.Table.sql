USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkTrslDet]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkTrslDet](
	[Acct] [char](10) NOT NULL,
	[DstCurrPTDBal] [float] NOT NULL,
	[DstCurrYTDBal] [float] NOT NULL,
	[DstPriorYTDBal] [float] NOT NULL,
	[OpenBalTrslAmt] [float] NOT NULL,
	[PerActTrslAmt] [float] NOT NULL,
	[Period] [char](6) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SrcCurrPTDBal] [float] NOT NULL,
	[SrcCurrYTDBal] [float] NOT NULL,
	[SrcPriorYTDBal] [float] NOT NULL,
	[TrslID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkTrslDet0] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[TrslID] ASC,
	[Period] ASC,
	[Acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
