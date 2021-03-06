USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[ARHist]    Script Date: 12/21/2015 14:33:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ARHist](
	[AccruedRevBegBal] [float] NOT NULL,
	[BegBal] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NbrInvcPaid00] [float] NOT NULL,
	[NbrInvcPaid01] [float] NOT NULL,
	[NbrInvcPaid02] [float] NOT NULL,
	[NbrInvcPaid03] [float] NOT NULL,
	[NbrInvcPaid04] [float] NOT NULL,
	[NbrInvcPaid05] [float] NOT NULL,
	[NbrInvcPaid06] [float] NOT NULL,
	[NbrInvcPaid07] [float] NOT NULL,
	[NbrInvcPaid08] [float] NOT NULL,
	[NbrInvcPaid09] [float] NOT NULL,
	[NbrInvcPaid10] [float] NOT NULL,
	[NbrInvcPaid11] [float] NOT NULL,
	[NbrInvcPaid12] [float] NOT NULL,
	[NoteId] [int] NOT NULL,
	[PaidInvcDays00] [float] NOT NULL,
	[PaidInvcDays01] [float] NOT NULL,
	[PaidInvcDays02] [float] NOT NULL,
	[PaidInvcDays03] [float] NOT NULL,
	[PaidInvcDays04] [float] NOT NULL,
	[PaidInvcDays05] [float] NOT NULL,
	[PaidInvcDays06] [float] NOT NULL,
	[PaidInvcDays07] [float] NOT NULL,
	[PaidInvcDays08] [float] NOT NULL,
	[PaidInvcDays09] [float] NOT NULL,
	[PaidInvcDays10] [float] NOT NULL,
	[PaidInvcDays11] [float] NOT NULL,
	[PaidInvcDays12] [float] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PTDAccruedRev00] [float] NOT NULL,
	[PTDAccruedRev01] [float] NOT NULL,
	[PTDAccruedRev02] [float] NOT NULL,
	[PTDAccruedRev03] [float] NOT NULL,
	[PTDAccruedRev04] [float] NOT NULL,
	[PTDAccruedRev05] [float] NOT NULL,
	[PTDAccruedRev06] [float] NOT NULL,
	[PTDAccruedRev07] [float] NOT NULL,
	[PTDAccruedRev08] [float] NOT NULL,
	[PTDAccruedRev09] [float] NOT NULL,
	[PTDAccruedRev10] [float] NOT NULL,
	[PTDAccruedRev11] [float] NOT NULL,
	[PTDAccruedRev12] [float] NOT NULL,
	[PTDCOGS00] [float] NOT NULL,
	[PTDCOGS01] [float] NOT NULL,
	[PTDCOGS02] [float] NOT NULL,
	[PTDCOGS03] [float] NOT NULL,
	[PTDCOGS04] [float] NOT NULL,
	[PTDCOGS05] [float] NOT NULL,
	[PTDCOGS06] [float] NOT NULL,
	[PTDCOGS07] [float] NOT NULL,
	[PTDCOGS08] [float] NOT NULL,
	[PTDCOGS09] [float] NOT NULL,
	[PTDCOGS10] [float] NOT NULL,
	[PTDCOGS11] [float] NOT NULL,
	[PTDCOGS12] [float] NOT NULL,
	[PTDCrMemo00] [float] NOT NULL,
	[PTDCrMemo01] [float] NOT NULL,
	[PTDCrMemo02] [float] NOT NULL,
	[PTDCrMemo03] [float] NOT NULL,
	[PTDCrMemo04] [float] NOT NULL,
	[PTDCrMemo05] [float] NOT NULL,
	[PTDCrMemo06] [float] NOT NULL,
	[PTDCrMemo07] [float] NOT NULL,
	[PTDCrMemo08] [float] NOT NULL,
	[PTDCrMemo09] [float] NOT NULL,
	[PTDCrMemo10] [float] NOT NULL,
	[PTDCrMemo11] [float] NOT NULL,
	[PTDCrMemo12] [float] NOT NULL,
	[PTDDisc00] [float] NOT NULL,
	[PTDDisc01] [float] NOT NULL,
	[PTDDisc02] [float] NOT NULL,
	[PTDDisc03] [float] NOT NULL,
	[PTDDisc04] [float] NOT NULL,
	[PTDDisc05] [float] NOT NULL,
	[PTDDisc06] [float] NOT NULL,
	[PTDDisc07] [float] NOT NULL,
	[PTDDisc08] [float] NOT NULL,
	[PTDDisc09] [float] NOT NULL,
	[PTDDisc10] [float] NOT NULL,
	[PTDDisc11] [float] NOT NULL,
	[PTDDisc12] [float] NOT NULL,
	[PTDDrMemo00] [float] NOT NULL,
	[PTDDrMemo01] [float] NOT NULL,
	[PTDDrMemo02] [float] NOT NULL,
	[PTDDrMemo03] [float] NOT NULL,
	[PTDDrMemo04] [float] NOT NULL,
	[PTDDrMemo05] [float] NOT NULL,
	[PTDDrMemo06] [float] NOT NULL,
	[PTDDrMemo07] [float] NOT NULL,
	[PTDDrMemo08] [float] NOT NULL,
	[PTDDrMemo09] [float] NOT NULL,
	[PTDDrMemo10] [float] NOT NULL,
	[PTDDrMemo11] [float] NOT NULL,
	[PTDDrMemo12] [float] NOT NULL,
	[PTDFinChrg00] [float] NOT NULL,
	[PTDFinChrg01] [float] NOT NULL,
	[PTDFinChrg02] [float] NOT NULL,
	[PTDFinChrg03] [float] NOT NULL,
	[PTDFinChrg04] [float] NOT NULL,
	[PTDFinChrg05] [float] NOT NULL,
	[PTDFinChrg06] [float] NOT NULL,
	[PTDFinChrg07] [float] NOT NULL,
	[PTDFinChrg08] [float] NOT NULL,
	[PTDFinChrg09] [float] NOT NULL,
	[PTDFinChrg10] [float] NOT NULL,
	[PTDFinChrg11] [float] NOT NULL,
	[PTDFinChrg12] [float] NOT NULL,
	[PTDRcpt00] [float] NOT NULL,
	[PTDRcpt01] [float] NOT NULL,
	[PTDRcpt02] [float] NOT NULL,
	[PTDRcpt03] [float] NOT NULL,
	[PTDRcpt04] [float] NOT NULL,
	[PTDRcpt05] [float] NOT NULL,
	[PTDRcpt06] [float] NOT NULL,
	[PTDRcpt07] [float] NOT NULL,
	[PTDRcpt08] [float] NOT NULL,
	[PTDRcpt09] [float] NOT NULL,
	[PTDRcpt10] [float] NOT NULL,
	[PTDRcpt11] [float] NOT NULL,
	[PTDRcpt12] [float] NOT NULL,
	[PTDSales00] [float] NOT NULL,
	[PTDSales01] [float] NOT NULL,
	[PTDSales02] [float] NOT NULL,
	[PTDSales03] [float] NOT NULL,
	[PTDSales04] [float] NOT NULL,
	[PTDSales05] [float] NOT NULL,
	[PTDSales06] [float] NOT NULL,
	[PTDSales07] [float] NOT NULL,
	[PTDSales08] [float] NOT NULL,
	[PTDSales09] [float] NOT NULL,
	[PTDSales10] [float] NOT NULL,
	[PTDSales11] [float] NOT NULL,
	[PTDSales12] [float] NOT NULL,
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
	[YTDAccruedRev] [float] NOT NULL,
	[YtdCOGS] [float] NOT NULL,
	[YtdCrMemo] [float] NOT NULL,
	[YtdDisc] [float] NOT NULL,
	[YtdDrMemo] [float] NOT NULL,
	[YtdFinChrg] [float] NOT NULL,
	[YtdRcpt] [float] NOT NULL,
	[YtdSales] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [ARHist0] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[CpnyID] ASC,
	[FiscYr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
