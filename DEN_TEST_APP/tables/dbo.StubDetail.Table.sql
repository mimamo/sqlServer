USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[StubDetail]    Script Date: 12/21/2015 14:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StubDetail](
	[Acct] [char](10) NOT NULL,
	[BCurrAvail] [float] NOT NULL,
	[BCurrUsed] [float] NOT NULL,
	[BCurrWorked] [float] NOT NULL,
	[BTotWorked] [float] NOT NULL,
	[BYBegBal] [float] NOT NULL,
	[BYTDAccr] [float] NOT NULL,
	[BYTDAvail] [float] NOT NULL,
	[BYTDUsed] [float] NOT NULL,
	[BYTDWorked] [float] NOT NULL,
	[ChkNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[EDCalYTDAmt] [float] NOT NULL,
	[EDCurrAmt] [float] NOT NULL,
	[EDCurrUnits] [float] NOT NULL,
	[EmpId] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NetPay] [smallint] NOT NULL,
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
	[StubType] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TypeId] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WrkLocId] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [StubDetail0] PRIMARY KEY CLUSTERED 
(
	[Acct] ASC,
	[Sub] ASC,
	[ChkNbr] ASC,
	[DocType] ASC,
	[StubType] ASC,
	[TypeId] ASC,
	[WrkLocId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
