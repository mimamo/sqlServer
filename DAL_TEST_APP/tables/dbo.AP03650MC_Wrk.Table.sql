USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[AP03650MC_Wrk]    Script Date: 12/21/2015 13:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP03650MC_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[CpnyID] [char](10) NULL,
	[CuryDocBal] [float] NULL,
	[DocBal] [float] NULL,
	[CuryId] [char](4) NULL,
	[CuryOrigDocAmt] [float] NULL,
	[DocClass] [char](1) NULL,
	[DocDate] [smalldatetime] NULL,
	[DocType] [char](2) NULL,
	[InvcDate] [smalldatetime] NULL,
	[OrigDocAmt] [float] NULL,
	[PerClosed] [char](6) NULL,
	[PerEnt] [char](6) NULL,
	[PerPost] [char](6) NULL,
	[RefNbr] [char](10) NULL,
	[Rlsed] [smallint] NULL,
	[Status] [char](1) NULL,
	[VendId] [char](15) NULL,
	[InvcNbr] [char](15) NULL,
	[Vendor_Name] [char](60) NOT NULL,
	[Vendor_APAcct] [char](10) NULL,
	[Vendor_APSub] [char](24) NULL,
	[GLSetup_BaseCuryID] [char](4) NULL,
	[APAdjust_AdjAmt] [float] NULL,
	[APAdjust_AdjdDocType] [char](2) NULL,
	[APAdjust_AdjDiscAmt] [float] NULL,
	[APAdjust_AdjdRefNbr] [char](10) NULL,
	[APAdjust_AdjgAcct] [char](10) NULL,
	[APAdjust_AdjgDocType] [char](2) NULL,
	[APAdjust_AdjgRefNbr] [char](10) NULL,
	[APAdjust_AdjgSub] [char](24) NULL,
	[APAdjust_CuryAdjgAmt] [float] NULL,
	[APAdjust_CuryAdjdAmt] [float] NULL,
	[APAdj_CuryAdjdDscAmt] [float] NULL,
	[APDoc1_CpnyID] [char](10) NULL,
	[APDoc1_DocDate] [smalldatetime] NULL,
	[APDoc1_DocType] [char](2) NULL,
	[APDoc1_PerClosed] [char](6) NULL,
	[APDoc1_PerEnt] [char](6) NULL,
	[APDoc1_PerPost] [char](6) NULL,
	[APDoc1_RefNbr] [char](10) NULL,
	[APDoc1_DocClass] [char](1) NULL,
	[APDoc1_VendID] [char](15) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
