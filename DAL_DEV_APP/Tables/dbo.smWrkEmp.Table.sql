USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[smWrkEmp]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkEmp](
	[ContractAmt] [float] NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
