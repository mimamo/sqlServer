USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[smWrkWeekly]    Script Date: 12/21/2015 13:56:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkWeekly](
	[BillHours] [float] NOT NULL,
	[EarningType] [char](10) NOT NULL,
	[EarnMult] [float] NOT NULL,
	[InvAmt] [float] NOT NULL,
	[InvCost] [float] NOT NULL,
	[InvGM] [float] NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[ServiceCallID] [char](10) NOT NULL,
	[Supervisor] [char](10) NOT NULL,
	[SVFirstName] [char](16) NOT NULL,
	[SVLastName] [char](16) NOT NULL,
	[SVMidName] [char](2) NOT NULL,
	[TechFirstName] [char](60) NOT NULL,
	[TechLastName] [char](60) NOT NULL,
	[TechMidName] [char](60) NOT NULL,
	[Technician] [char](10) NOT NULL,
	[TotalCost] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[WorkHours] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
