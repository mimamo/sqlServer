USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[AR08620_Wrk]    Script Date: 12/21/2015 14:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AR08620_Wrk](
	[RI_ID] [smallint] NULL,
	[ARAcct] [char](10) NULL,
	[ARSub] [char](24) NULL,
	[CurrBal] [float] NULL,
	[CustId] [char](15) NULL,
	[Name] [char](60) NOT NULL,
	[PerNbr] [char](6) NULL,
	[ARDoc_CuryDocBal] [float] NULL,
	[ARDoc_CuryId] [char](4) NULL,
	[ARDoc_CuryOrigDocAmt] [float] NULL,
	[ARDoc_CustId] [char](15) NULL,
	[ARDoc_DocBal] [float] NULL,
	[ARDoc_DocDate] [smalldatetime] NULL,
	[ARDoc_DocDesc] [char](30) NULL,
	[ARDoc_DocType] [char](2) NULL,
	[ARDoc_OrigDocAmt] [float] NULL,
	[ARDoc_PerClosed] [char](6) NULL,
	[ARDoc_PerEnt] [char](6) NULL,
	[ARDoc_PerPost] [char](6) NULL,
	[ARDoc_RefNbr] [char](10) NULL,
	[ARDoc_Rlsed] [smallint] NULL,
	[ARAdj_AdjAmt] [float] NULL,
	[ARAdj_AdjDiscAmt] [float] NULL,
	[ARAdj_CuryAdjDiscAmt] [float] NULL,
	[ARAdj_CuryAdjgAmt] [float] NULL,
	[ARDoc1_DocDate] [smalldatetime] NULL,
	[ARDoc1_DocDesc] [char](30) NULL,
	[ARDoc1_DocType] [char](2) NULL,
	[ARDoc1_PerClosed] [char](6) NULL,
	[ARDoc1_PerEnt] [char](6) NULL,
	[ARDoc1_PerPost] [char](6) NULL,
	[ARDoc1_RefNbr] [char](10) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
