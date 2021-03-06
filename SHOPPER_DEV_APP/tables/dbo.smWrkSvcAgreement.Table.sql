USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[smWrkSvcAgreement]    Script Date: 12/21/2015 14:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkSvcAgreement](
	[Actual1] [float] NOT NULL,
	[Actual2] [float] NOT NULL,
	[Actual3] [float] NOT NULL,
	[Actual4] [float] NOT NULL,
	[Actual5] [float] NOT NULL,
	[Actual6] [float] NOT NULL,
	[Actual7] [float] NOT NULL,
	[Actual8] [float] NOT NULL,
	[Actual9] [float] NOT NULL,
	[Actual10] [float] NOT NULL,
	[Actual11] [float] NOT NULL,
	[Actual12] [float] NOT NULL,
	[Budget1] [float] NOT NULL,
	[Budget2] [float] NOT NULL,
	[Budget3] [float] NOT NULL,
	[Budget4] [float] NOT NULL,
	[Budget5] [float] NOT NULL,
	[Budget6] [float] NOT NULL,
	[Budget7] [float] NOT NULL,
	[Budget8] [float] NOT NULL,
	[Budget9] [float] NOT NULL,
	[Budget10] [float] NOT NULL,
	[Budget11] [float] NOT NULL,
	[Budget12] [float] NOT NULL,
	[ContractID] [char](10) NOT NULL,
	[EstTime] [char](4) NOT NULL,
	[LaborBudget] [float] NOT NULL,
	[LaborCost] [float] NOT NULL,
	[LaborHours] [float] NOT NULL,
	[OtherCost] [float] NOT NULL,
	[RevAmount] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Sequence] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
