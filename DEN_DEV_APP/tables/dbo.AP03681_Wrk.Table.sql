USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[AP03681_Wrk]    Script Date: 12/21/2015 14:05:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP03681_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[CpnyID] [char](10) NULL,
	[DiscDate] [smalldatetime] NULL,
	[DocDate] [smalldatetime] NULL,
	[DocType] [char](2) NULL,
	[DueDate] [smalldatetime] NULL,
	[InvcDate] [smalldatetime] NULL,
	[InvcNbr] [char](15) NULL,
	[OrigDocAmt] [float] NULL,
	[PayDate] [smalldatetime] NULL,
	[PerPost] [char](6) NULL,
	[RefNbr] [char](10) NULL,
	[Rlsed] [smallint] NULL,
	[Status] [char](1) NULL,
	[VendId] [char](15) NULL,
	[DocBal] [float] NULL,
	[CuryDocBal] [float] NULL,
	[CuryId] [char](4) NULL,
	[APAdjust_AdjAmt] [float] NULL,
	[APAdjust_AdjDiscAmt] [float] NULL,
	[APAdjust_AdjgAcct] [char](10) NULL,
	[APAdjust_AdjgDocType] [char](2) NULL,
	[APAdjust_AdjgPerPost] [char](6) NULL,
	[APAdjust_AdjgRefNbr] [char](10) NULL,
	[APAdjust_AdjgSub] [char](24) NULL,
	[APAdjust_PerAppl] [char](6) NULL,
	[Vendor_Name] [char](60) NOT NULL,
	[Vendor_Status] [char](1) NULL,
	[Vendor_CuryId] [char](4) NULL,
	[APDocCk_DocDate] [smalldatetime] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
