USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[AP03615_Wrk]    Script Date: 12/21/2015 16:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP03615_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[BatNbr] [char](10) NULL,
	[CpnyID] [char](10) NULL,
	[CuryDiscBal] [float] NULL,
	[CuryDiscTkn] [float] NULL,
	[CuryDocBal] [float] NULL,
	[DiscDate] [smalldatetime] NULL,
	[DocType] [char](2) NULL,
	[DueDate] [smalldatetime] NULL,
	[InvcDate] [smalldatetime] NULL,
	[InvcNbr] [char](15) NULL,
	[PayDate] [smalldatetime] NULL,
	[RefNbr] [char](10) NULL,
	[Status] [char](1) NULL,
	[Vendor_Name] [char](60) NOT NULL,
	[Vendor_Status] [char](1) NULL,
	[Vendor_VendId] [char](15) NULL,
	[APTran_CpnyID] [char](10) NULL,
	[APTran_CuryTranAmt] [float] NULL,
	[APTran_CuryUnitPrice] [float] NULL,
	[APTran_DrCr] [char](1) NULL,
	[APTran_ExtRefNbr] [char](15) NULL,
	[APTran_RefNbr] [char](10) NULL,
	[APTran_TranType] [char](2) NULL,
	[APTran_VendId] [char](15) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
