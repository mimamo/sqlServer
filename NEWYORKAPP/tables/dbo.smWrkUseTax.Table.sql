USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[smWrkUseTax]    Script Date: 12/21/2015 16:00:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkUseTax](
	[CompleteDate] [smalldatetime] NOT NULL,
	[Cost] [float] NOT NULL,
	[CustID] [char](15) NOT NULL,
	[InvtId] [char](20) NOT NULL,
	[LineTypes] [char](1) NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[PostToPeriod] [char](6) NOT NULL,
	[Quantity] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[ServiceCallID] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[StdCost] [float] NOT NULL,
	[TaxAmt] [float] NOT NULL,
	[TaxID] [char](10) NOT NULL,
	[TxblAmt] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
