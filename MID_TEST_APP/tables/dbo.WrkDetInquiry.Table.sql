USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkDetInquiry]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkDetInquiry](
	[Acct] [char](10) NOT NULL,
	[Amount] [float] NOT NULL,
	[BatchNbr] [char](10) NOT NULL,
	[ExtRef] [char](15) NOT NULL,
	[FiscYr] [char](6) NOT NULL,
	[Journal] [char](3) NOT NULL,
	[Module] [char](2) NOT NULL,
	[PerBegBalance] [float] NOT NULL,
	[PerEndBalance] [float] NOT NULL,
	[PerFrom] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PerThru] [char](6) NOT NULL,
	[Ref] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[RptNbr] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[VendorName] [char](60) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
