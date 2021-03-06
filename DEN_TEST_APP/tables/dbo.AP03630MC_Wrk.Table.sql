USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[AP03630MC_Wrk]    Script Date: 12/21/2015 14:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP03630MC_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[Acct] [char](10) NULL,
	[BatNbr] [char](10) NULL,
	[CpnyID] [char](10) NULL,
	[CuryId] [char](4) NULL,
	[DocClass] [char](1) NULL,
	[DocDate] [smalldatetime] NULL,
	[DocType] [char](2) NULL,
	[OrigDocAmt] [float] NULL,
	[CuryOrigDocAmt] [float] NULL,
	[PerClosed] [char](6) NULL,
	[PerPost] [char](6) NULL,
	[RefNbr] [char](10) NULL,
	[Sub] [char](24) NULL,
	[VendId] [char](15) NULL,
	[Vendor_Name] [char](60) NOT NULL,
	[GLSetup_BaseCuryID] [char](4) NULL,
	[APAdjust_AdjAmt] [float] NULL,
	[APAdjust_AdjDiscAmt] [float] NULL,
	[APAdjust_AdjgPerPost] [char](6) NULL,
	[APAdjust_CuryAdjdAmt] [float] NULL,
	[APAdj_CuryAdjdDscAmt] [float] NULL,
	[APAdjust_AdjdRefNbr] [char](10) NULL,
	[APAdjust_AdjddocType] [char](2) NULL,
	[APDocVO_CpnyID] [char](10) NULL,
	[APDocVO_CuryID] [char](4) NULL,
	[APDocVO_DocType] [char](2) NULL,
	[APDocVO_InvcDate] [smalldatetime] NULL,
	[APDocVO_InvcNbr] [char](15) NULL,
	[APDocVO_RefNbr] [char](10) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
