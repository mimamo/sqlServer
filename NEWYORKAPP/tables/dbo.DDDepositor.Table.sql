USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[DDDepositor]    Script Date: 12/21/2015 16:00:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DDDepositor](
	[AcctType00] [char](1) NOT NULL,
	[AcctType01] [char](1) NOT NULL,
	[AcctType02] [char](1) NOT NULL,
	[AcctType03] [char](1) NOT NULL,
	[AcctType04] [char](1) NOT NULL,
	[AcctType05] [char](1) NOT NULL,
	[Amount00] [float] NOT NULL,
	[Amount01] [float] NOT NULL,
	[Amount02] [float] NOT NULL,
	[Amount03] [float] NOT NULL,
	[Amount04] [float] NOT NULL,
	[BankAcct00] [char](17) NOT NULL,
	[BankAcct01] [char](17) NOT NULL,
	[BankAcct02] [char](17) NOT NULL,
	[BankAcct03] [char](17) NOT NULL,
	[BankAcct04] [char](17) NOT NULL,
	[BankAcct05] [char](17) NOT NULL,
	[BankID] [char](6) NOT NULL,
	[BankTransit00] [char](9) NOT NULL,
	[BankTransit01] [char](9) NOT NULL,
	[BankTransit02] [char](9) NOT NULL,
	[BankTransit03] [char](9) NOT NULL,
	[BankTransit04] [char](9) NOT NULL,
	[BankTransit05] [char](9) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DistType] [char](1) NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[LowPay] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PNStatus00] [char](1) NOT NULL,
	[PNStatus01] [char](1) NOT NULL,
	[PNStatus02] [char](1) NOT NULL,
	[PNStatus03] [char](1) NOT NULL,
	[PNStatus04] [char](1) NOT NULL,
	[PNStatus05] [char](1) NOT NULL,
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
 CONSTRAINT [DDDepositor0] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
