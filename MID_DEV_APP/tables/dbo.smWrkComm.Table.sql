USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[smWrkComm]    Script Date: 12/21/2015 14:16:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkComm](
	[AmtLabor] [float] NOT NULL,
	[AmtMaterial] [float] NOT NULL,
	[AmtMisc] [float] NOT NULL,
	[AmtTax] [float] NOT NULL,
	[CallNbr] [char](10) NOT NULL,
	[CommLabor] [float] NOT NULL,
	[CommMaterial] [float] NOT NULL,
	[CompletedDate] [smalldatetime] NOT NULL,
	[CustomerName] [char](60) NOT NULL,
	[EmployeeID] [char](10) NOT NULL,
	[EmployeeName] [char](60) NOT NULL,
	[InvNbr] [char](10) NOT NULL,
	[PeriodFrom] [char](10) NOT NULL,
	[PeriodTo] [char](10) NOT NULL,
	[SpecialCommission] [float] NOT NULL,
	[SplitPct] [float] NOT NULL,
	[TotalComm] [float] NOT NULL,
	[TotalInvoice] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [smalldatetime] NOT NULL,
	[User6] [smalldatetime] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
