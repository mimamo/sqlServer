USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PRCheckTran]    Script Date: 12/21/2015 13:44:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PRCheckTran](
	[ASID] [int] NOT NULL,
	[CheckPage] [smallint] NOT NULL,
	[ChkNbr] [char](10) NOT NULL,
	[ChkSeq] [char](2) NOT NULL,
	[Col1CurrAmt] [float] NOT NULL,
	[Col1CurrUnits] [float] NOT NULL,
	[Col1Descr] [char](30) NOT NULL,
	[Col1Id] [char](10) NOT NULL,
	[Col1NetPay] [smallint] NOT NULL,
	[Col1Type] [char](1) NOT NULL,
	[Col1YTDAmt] [float] NOT NULL,
	[Col2CurrAmt] [float] NOT NULL,
	[Col2Descr] [char](30) NOT NULL,
	[Col2Id] [char](10) NOT NULL,
	[Col2YTDAmt] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrEarn] [float] NOT NULL,
	[CurrNet] [float] NOT NULL,
	[CurrPayPerEndDate] [smalldatetime] NOT NULL,
	[CurrPayPerStrtDate] [smalldatetime] NOT NULL,
	[EmpId] [char](10) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PerQSent] [char](6) NOT NULL,
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
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PRCheckTran0] PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC,
	[ChkSeq] ASC,
	[LineNbr] ASC,
	[ASID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
