USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[AR08820_Wrk]    Script Date: 12/21/2015 15:54:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AR08820_Wrk](
	[RI_ID] [smallint] NULL,
	[AdjAmt] [float] NULL,
	[AdjBatNbr] [char](10) NULL,
	[AdjDDocType] [char](2) NULL,
	[AdjDiscAmt] [float] NULL,
	[AdjDRefNbr] [char](10) NULL,
	[AdjGDocType] [char](2) NULL,
	[AdjGRefNbr] [char](10) NULL,
	[CpnyID] [char](10) NULL,
	[CustID] [char](15) NULL,
	[CuryAdjDAmt] [float] NULL,
	[CuryAdjDDiscAmt] [float] NULL,
	[AdjGDoc_BatNbr] [char](10) NULL,
	[AdjGDoc_DiscBal] [float] NULL,
	[AdjGDoc_DocBal] [float] NULL,
	[AdjGDoc_DocDate] [smalldatetime] NULL,
	[AdjGDoc_DocDesc] [char](30) NULL,
	[AdjGDoc_OrigDocAmt] [float] NULL,
	[AdjGDoc_PerPost] [char](6) NULL,
	[AdjGDoc_CuryDiscBal] [float] NULL,
	[AdjGDoc_CuryDocBal] [float] NULL,
	[AdjGDoc_CuryId] [char](4) NULL,
	[AdjGDoc_CuryODocAmt] [float] NULL,
	[AdjDDoc_DiscDate] [smalldatetime] NULL,
	[AdjDDoc_DocDate] [smalldatetime] NULL,
	[AdjDDoc_DueDate] [smalldatetime] NULL,
	[AdjDDoc_OrigDocAmt] [float] NULL,
	[AdjDDoc_PerClosed] [char](6) NULL,
	[AdjDDoc_Terms] [char](2) NULL,
	[AdjDDoc_CuryID] [char](4) NULL,
	[Customer_Name] [char](60) NOT NULL,
	[Terms_Descr] [char](30) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
