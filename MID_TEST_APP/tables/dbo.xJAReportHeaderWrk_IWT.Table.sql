USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xJAReportHeaderWrk_IWT]    Script Date: 12/21/2015 14:26:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJAReportHeaderWrk_IWT](
	[SessionGUID] [varchar](255) NOT NULL,
	[Project] [varchar](16) NULL,
	[AgingDate] [smalldatetime] NULL,
	[ASName] [varchar](60) NULL,
	[ClientName] [varchar](30) NULL,
	[ClientEMail] [varchar](50) NULL,
	[CpnyID] [varchar](10) NULL,
	[CustID] [varchar](15) NULL,
	[CustomerName] [varchar](60) NULL,
	[End_Date] [smalldatetime] NULL,
	[HasChildren] [smallint] NULL,
	[Inv_format_cd] [varchar](4) NULL,
	[Pm_id01] [varchar](30) NULL,
	[Pm_id02] [varchar](30) NULL,
	[Pm_id08] [smalldatetime] NULL,
	[Pm_id28] [smalldatetime] NULL,
	[Pm_id32] [varchar](30) NULL,
	[PMName] [varchar](60) NULL,
	[Project_BillWith] [varchar](16) NULL,
	[Project_desc] [varchar](60) NULL,
	[ProdCode] [varchar](30) NULL,
	[Purchase_order_num] [varchar](20) NULL,
	[Start_Date] [smalldatetime] NULL,
	[Status_pa] [varchar](1) NULL,
	[Tot_Estimate] [decimal](15, 3) NULL,
	[Tot_FeesCost] [decimal](15, 3) NULL,
	[Tot_FeesBill] [decimal](15, 3) NULL,
	[Tot_Hours] [decimal](15, 3) NULL,
	[Tot_Payments] [decimal](15, 3) NULL,
	[Tot_PreBill] [decimal](15, 3) NULL,
	[Tot_POCost] [decimal](15, 3) NULL,
	[Tot_VendorBill] [decimal](15, 3) NULL,
	[Tot_VendorCost] [decimal](15, 3) NULL,
	[Tot_WIPAPSBill] [decimal](15, 3) NULL,
	[Tot_WIPAPSCost] [decimal](15, 3) NULL,
	[CurrentLockedEstimate] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
