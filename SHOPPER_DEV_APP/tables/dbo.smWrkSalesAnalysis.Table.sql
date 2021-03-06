USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[smWrkSalesAnalysis]    Script Date: 12/21/2015 14:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkSalesAnalysis](
	[CallType] [char](10) NOT NULL,
	[CurCost] [float] NOT NULL,
	[CurHours] [float] NOT NULL,
	[CurNbrCalls] [smallint] NOT NULL,
	[CurRevenue] [float] NOT NULL,
	[CustClass] [char](6) NOT NULL,
	[InvoiceType] [char](1) NOT NULL,
	[PrintMonth] [smallint] NOT NULL,
	[PrintYear] [smallint] NOT NULL,
	[PriorCost] [float] NOT NULL,
	[PriorHours] [float] NOT NULL,
	[PriorNbrCalls] [smallint] NOT NULL,
	[PriorRevenue] [float] NOT NULL,
	[RecType] [char](1) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[ServiceCallID] [char](10) NOT NULL,
	[ServiceContractId] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
