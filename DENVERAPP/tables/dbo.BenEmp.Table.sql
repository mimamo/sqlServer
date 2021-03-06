USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[BenEmp]    Script Date: 12/21/2015 15:42:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BenEmp](
	[BenId] [char](10) NOT NULL,
	[BTotWorked] [float] NOT NULL,
	[BYBegBal] [float] NOT NULL,
	[BYTDAccr] [float] NOT NULL,
	[BYTDAvail] [float] NOT NULL,
	[BYTDUsed] [float] NOT NULL,
	[BYTDWorked] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrAvail] [float] NOT NULL,
	[CurrBYBegBal] [float] NOT NULL,
	[CurrBYTDAccr] [float] NOT NULL,
	[CurrBYTDAvail] [float] NOT NULL,
	[CurrBYTDUsed] [float] NOT NULL,
	[CurrBYTDWorked] [float] NOT NULL,
	[CurrLastAvailDate] [smalldatetime] NOT NULL,
	[CurrLastCloseDate] [smalldatetime] NOT NULL,
	[CurrLastPayPEndDate] [smalldatetime] NOT NULL,
	[CurrUsed] [float] NOT NULL,
	[CurrWorked] [float] NOT NULL,
	[EmpId] [char](10) NOT NULL,
	[LastAccrRate] [float] NOT NULL,
	[LastAvailDate] [smalldatetime] NOT NULL,
	[LastCloseDate] [smalldatetime] NOT NULL,
	[LastPayPerEndDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaxCarryOver] [float] NOT NULL,
	[NoteId] [int] NOT NULL,
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
	[Status] [char](2) NOT NULL,
	[TrnsBenId] [char](10) NOT NULL,
	[TrnsCarryFwdHist] [smallint] NOT NULL,
	[TrnsDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [BenEmp0] PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC,
	[BenId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
