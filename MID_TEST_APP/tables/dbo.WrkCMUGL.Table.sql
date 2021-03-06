USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkCMUGL]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkCMUGL](
	[CalcBasePmtAmt] [float] NOT NULL,
	[CalcMultDiv] [char](1) NOT NULL,
	[CalcRate] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryPmtAmt] [float] NOT NULL,
	[CustId] [char](15) NOT NULL,
	[DocStatus] [char](1) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[OrigBasePmtAmt] [float] NOT NULL,
	[OrigMultDiv] [char](1) NOT NULL,
	[OrigRate] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[UGOLAcct] [char](10) NOT NULL,
	[UGOLSub] [char](24) NOT NULL,
	[UnrlGain] [float] NOT NULL,
	[UnrlLoss] [float] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkCMUGL0] PRIMARY KEY CLUSTERED 
(
	[CuryId] ASC,
	[DocType] ASC,
	[RefNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
