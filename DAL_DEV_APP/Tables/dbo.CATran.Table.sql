USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[CATran]    Script Date: 12/21/2015 13:35:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CATran](
	[Acct] [char](10) NOT NULL,
	[AcctDist] [smallint] NOT NULL,
	[bankacct] [char](10) NOT NULL,
	[BankCpnyID] [char](10) NOT NULL,
	[banksub] [char](24) NOT NULL,
	[batnbr] [char](10) NOT NULL,
	[ClearAmt] [float] NOT NULL,
	[ClearDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[curytranamt] [float] NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[EmployeeID] [char](10) NOT NULL,
	[EntryId] [char](2) NOT NULL,
	[JrnlType] [char](3) NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LineID] [int] NOT NULL,
	[Linenbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PayeeID] [char](15) NOT NULL,
	[PC_Flag] [char](1) NOT NULL,
	[PC_ID] [char](20) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[Perent] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[RcnclStatus] [char](1) NOT NULL,
	[RecurId] [char](10) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Rlsed] [smallint] NOT NULL,
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
	[TaskID] [char](32) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[trsftobankacct] [char](10) NOT NULL,
	[trsftobanksub] [char](24) NOT NULL,
	[TrsfToCpnyID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [CATran0] PRIMARY KEY CLUSTERED 
(
	[Module] ASC,
	[batnbr] ASC,
	[Linenbr] ASC,
	[BankCpnyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
