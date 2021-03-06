USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkCheckSel]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkCheckSel](
	[AccessNbr] [smallint] NOT NULL,
	[Acct] [char](10) NOT NULL,
	[AdjFlag] [smallint] NOT NULL,
	[ApplyRefNbr] [char](10) NOT NULL,
	[CheckCuryId] [char](4) NOT NULL,
	[CheckCuryRate] [float] NOT NULL,
	[CheckCuryMultDiv] [char](1) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CheckRefNbr] [char](10) NULL,
	[CuryDecPl] [smallint] NOT NULL,
	[CuryDiscBal] [float] NOT NULL,
	[CuryDiscTkn] [float] NOT NULL,
	[CuryDocBal] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPmtAmt] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[DiscBal] [float] NOT NULL,
	[DiscDate] [smalldatetime] NOT NULL,
	[DiscTkn] [float] NOT NULL,
	[DocBal] [float] NOT NULL,
	[DocDesc] [char](30) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[DueDate] [smalldatetime] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[MultiChk] [smallint] NOT NULL,
	[PayDate] [smalldatetime] NOT NULL,
	[PmtAmt] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
