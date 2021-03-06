USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[CashAcct]    Script Date: 12/21/2015 16:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CashAcct](
	[AcceptGLUpdates] [smallint] NOT NULL,
	[AcctNbr] [char](30) NOT NULL,
	[AcctType] [char](1) NOT NULL,
	[Active] [smallint] NOT NULL,
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[AddrID] [char](10) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[BankAcct] [char](10) NOT NULL,
	[BankID] [char](10) NOT NULL,
	[BankSub] [char](24) NOT NULL,
	[CashAcctName] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrentBal] [float] NOT NULL,
	[curycurrentbal] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[Fax] [char](15) NOT NULL,
	[LastAutoCheckNbr] [char](10) NOT NULL,
	[LastManualCheckNbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](30) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Phone] [char](15) NOT NULL,
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
	[Salut] [char](30) NOT NULL,
	[State] [char](3) NOT NULL,
	[transitnbr] [char](9) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [cashacct0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[BankAcct] ASC,
	[BankSub] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
