USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[BRBankTran]    Script Date: 12/21/2015 14:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BRBankTran](
	[AcctID] [char](10) NOT NULL,
	[BankRefNbr] [char](10) NOT NULL,
	[BookRefNbr] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrPerNbr] [char](6) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[Future01] [char](30) NOT NULL,
	[Future02] [char](10) NOT NULL,
	[Future03] [smalldatetime] NOT NULL,
	[Future04] [float] NOT NULL,
	[Future05] [int] NOT NULL,
	[Future06] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
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
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](30) NOT NULL,
	[User01] [char](30) NOT NULL,
	[User02] [char](30) NOT NULL,
	[User03] [char](10) NOT NULL,
	[User04] [char](10) NOT NULL,
	[User05] [smalldatetime] NOT NULL,
	[User06] [smalldatetime] NOT NULL,
	[User07] [float] NOT NULL,
	[User08] [float] NOT NULL,
	[User09] [int] NOT NULL,
	[User10] [int] NOT NULL,
	[User11] [smallint] NOT NULL,
	[User12] [smallint] NOT NULL,
	[TStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
