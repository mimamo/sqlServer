USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[WrkCADetail]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkCADetail](
	[bankacct] [char](10) NOT NULL,
	[banksub] [char](24) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[ClearAmt] [float] NOT NULL,
	[ClearDate] [smalldatetime] NOT NULL,
	[Cleared] [smallint] NOT NULL,
	[cpnyid] [char](10) NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryTranamt] [float] NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[EntryID] [char](2) NOT NULL,
	[Module] [char](2) NOT NULL,
	[PayeeID] [char](15) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[Perent] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RcnclStatus] [char](1) NOT NULL,
	[Rcptdisbflg] [char](1) NOT NULL,
	[Refnbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[Tranamt] [float] NOT NULL,
	[Trandate] [smalldatetime] NOT NULL,
	[Trandesc] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
