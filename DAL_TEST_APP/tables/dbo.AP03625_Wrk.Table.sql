USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[AP03625_Wrk]    Script Date: 12/21/2015 13:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP03625_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[Acct] [char](10) NULL,
	[BatNbr] [char](10) NULL,
	[CpnyID] [char](10) NULL,
	[DocClass] [char](1) NULL,
	[DocCnt] [float] NULL,
	[DocDate] [smalldatetime] NULL,
	[DocType] [char](2) NULL,
	[OrigDocAmt] [float] NULL,
	[RefNbr] [char](10) NULL,
	[Sub] [char](24) NULL,
	[VendId] [char](15) NULL,
	[CuryID] [char](4) NULL,
	[CuryOrigDocAmt] [float] NULL,
	[Vendor_Name] [char](60) NOT NULL,
	[Batch_Module] [char](2) NULL,
	[Batch_Status] [char](1) NULL,
	[APAdjust_AdjAmt] [float] NULL,
	[APAdjust_AdjdDocType] [char](2) NULL,
	[APAdjust_AdjDiscAmt] [float] NULL,
	[APAdjust_AdjdRefNbr] [char](10) NULL,
	[APAdjust_CuryAdjGAmt] [float] NULL,
	[APAdj_CuryAdjGDscAmt] [float] NULL,
	[APDocVO_CpnyID] [char](10) NULL,
	[APDocVO_DiscBal] [float] NULL,
	[APDocVO_DiscDate] [smalldatetime] NULL,
	[APDocVO_DueDate] [smalldatetime] NULL,
	[APDocVO_InvcDate] [smalldatetime] NULL,
	[APDocVO_InvcNbr] [char](15) NULL,
	[APDocVO_OrigDocAmt] [float] NULL,
	[APDocVO_PayDate] [smalldatetime] NULL,
	[APDocVO_RefNbr] [char](10) NULL,
	[APDocVO_Status] [char](2) NULL,
	[APDocVO_DocType] [char](2) NULL,
	[APDocVO_CuryDiscBal] [float] NULL,
	[APDVO_CuryOrigDocAmt] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
