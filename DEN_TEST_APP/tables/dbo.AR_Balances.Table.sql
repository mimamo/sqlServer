USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[AR_Balances]    Script Date: 12/21/2015 14:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AR_Balances](
	[AccruedRevAgeBal00] [float] NOT NULL,
	[AccruedRevAgeBal01] [float] NOT NULL,
	[AccruedRevAgeBal02] [float] NOT NULL,
	[AccruedRevAgeBal03] [float] NOT NULL,
	[AccruedRevAgeBal04] [float] NOT NULL,
	[AccruedRevBal] [float] NOT NULL,
	[AgeBal00] [float] NOT NULL,
	[AgeBal01] [float] NOT NULL,
	[AgeBal02] [float] NOT NULL,
	[AgeBal03] [float] NOT NULL,
	[AgeBal04] [float] NOT NULL,
	[AvgDayToPay] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CrLmt] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrBal] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryPromoBal] [float] NOT NULL,
	[CustID] [char](15) NOT NULL,
	[FutureBal] [float] NOT NULL,
	[LastActDate] [smalldatetime] NOT NULL,
	[LastAgeDate] [smalldatetime] NOT NULL,
	[LastFinChrgDate] [smalldatetime] NOT NULL,
	[LastInvcDate] [smalldatetime] NOT NULL,
	[LastStmtBal00] [float] NOT NULL,
	[LastStmtBal01] [float] NOT NULL,
	[LastStmtBal02] [float] NOT NULL,
	[LastStmtBal03] [float] NOT NULL,
	[LastStmtBal04] [float] NOT NULL,
	[LastStmtBegBal] [float] NOT NULL,
	[LastStmtDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NbrInvcPaid] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PaidInvcDays] [float] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PromoBal] [float] NOT NULL,
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
	[TotOpenOrd] [float] NOT NULL,
	[TotPrePay] [float] NOT NULL,
	[TotShipped] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [AR_Balances0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
