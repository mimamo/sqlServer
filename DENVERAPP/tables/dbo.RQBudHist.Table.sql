USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[RQBudHist]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RQBudHist](
	[Acct] [char](10) NOT NULL,
	[BegBal] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[LedgerId] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[PtdBal00] [float] NOT NULL,
	[PtdBal01] [float] NOT NULL,
	[PtdBal02] [float] NOT NULL,
	[PtdBal03] [float] NOT NULL,
	[PtdBal04] [float] NOT NULL,
	[PtdBal05] [float] NOT NULL,
	[PtdBal06] [float] NOT NULL,
	[PtdBal07] [float] NOT NULL,
	[PtdBal08] [float] NOT NULL,
	[PtdBal09] [float] NOT NULL,
	[PtdBal10] [float] NOT NULL,
	[PtdBal11] [float] NOT NULL,
	[PtdBal12] [float] NOT NULL,
	[S4Future1] [char](30) NOT NULL,
	[S4Future2] [char](30) NOT NULL,
	[S4Future3] [float] NOT NULL,
	[S4Future4] [float] NOT NULL,
	[S4Future5] [float] NOT NULL,
	[S4Future6] [float] NOT NULL,
	[S4Future7] [smalldatetime] NOT NULL,
	[S4Future8] [smalldatetime] NOT NULL,
	[S4Future9] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[YtdBal00] [float] NOT NULL,
	[YtdBal01] [float] NOT NULL,
	[YtdBal02] [float] NOT NULL,
	[YtdBal03] [float] NOT NULL,
	[YtdBal04] [float] NOT NULL,
	[YtdBal05] [float] NOT NULL,
	[YtdBal06] [float] NOT NULL,
	[YtdBal07] [float] NOT NULL,
	[YtdBal08] [float] NOT NULL,
	[YtdBal09] [float] NOT NULL,
	[YtdBal10] [float] NOT NULL,
	[YtdBal11] [float] NOT NULL,
	[YtdBal12] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
