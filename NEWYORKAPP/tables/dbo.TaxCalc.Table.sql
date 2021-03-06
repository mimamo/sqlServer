USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[TaxCalc]    Script Date: 12/21/2015 16:00:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TaxCalc](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryDetCostAmt] [float] NOT NULL,
	[CuryDetExtAmt] [float] NOT NULL,
	[CuryDetTaxAmt00] [float] NOT NULL,
	[CuryDetTaxAmt01] [float] NOT NULL,
	[CuryDetTaxAmt02] [float] NOT NULL,
	[CuryDetTaxAmt03] [float] NOT NULL,
	[CuryDetTaxSub00] [float] NOT NULL,
	[CuryDetTaxSub01] [float] NOT NULL,
	[CuryDetTaxSub02] [float] NOT NULL,
	[CuryDetTaxSub03] [float] NOT NULL,
	[CuryDetTotTax] [float] NOT NULL,
	[CuryDetTxblAmt00] [float] NOT NULL,
	[CuryDetTxblAmt01] [float] NOT NULL,
	[CuryDetTxblAmt02] [float] NOT NULL,
	[CuryDetTxblAmt03] [float] NOT NULL,
	[CuryDetTxblSub00] [float] NOT NULL,
	[CuryDetTxblSub01] [float] NOT NULL,
	[CuryDetTxblSub02] [float] NOT NULL,
	[CuryDetTxblSub03] [float] NOT NULL,
	[CuryDocTaxFrt00] [float] NOT NULL,
	[CuryDocTaxFrt01] [float] NOT NULL,
	[CuryDocTaxFrt02] [float] NOT NULL,
	[CuryDocTaxFrt03] [float] NOT NULL,
	[CuryDocTaxMisc00] [float] NOT NULL,
	[CuryDocTaxMisc01] [float] NOT NULL,
	[CuryDocTaxMisc02] [float] NOT NULL,
	[CuryDocTaxMisc03] [float] NOT NULL,
	[CuryDocTaxTot00] [float] NOT NULL,
	[CuryDocTaxTot01] [float] NOT NULL,
	[CuryDocTaxTot02] [float] NOT NULL,
	[CuryDocTaxTot03] [float] NOT NULL,
	[CuryDocTotal] [float] NOT NULL,
	[CuryDocTotTax] [float] NOT NULL,
	[CuryDocTxblFrt00] [float] NOT NULL,
	[CuryDocTxblFrt01] [float] NOT NULL,
	[CuryDocTxblFrt02] [float] NOT NULL,
	[CuryDocTxblFrt03] [float] NOT NULL,
	[CuryDocTxblMisc00] [float] NOT NULL,
	[CuryDocTxblMisc01] [float] NOT NULL,
	[CuryDocTxblMisc02] [float] NOT NULL,
	[CuryDocTxblMisc03] [float] NOT NULL,
	[CuryDocTxblTot00] [float] NOT NULL,
	[CuryDocTxblTot01] [float] NOT NULL,
	[CuryDocTxblTot02] [float] NOT NULL,
	[CuryDocTxblTot03] [float] NOT NULL,
	[CuryFreight] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMiscChrg] [float] NOT NULL,
	[CuryTaxBasisAmt] [float] NOT NULL,
	[DetLineID] [int] NOT NULL,
	[DetLineRef] [char](5) NOT NULL,
	[DetQty] [float] NOT NULL,
	[DetRowNbr] [smallint] NOT NULL,
	[DetTaxAmt00] [float] NOT NULL,
	[DetTaxAmt01] [float] NOT NULL,
	[DetTaxAmt02] [float] NOT NULL,
	[DetTaxAmt03] [float] NOT NULL,
	[DetTaxCat] [char](10) NOT NULL,
	[DetTaxID00] [char](10) NOT NULL,
	[DetTaxID01] [char](10) NOT NULL,
	[DetTaxID02] [char](10) NOT NULL,
	[DetTaxID03] [char](10) NOT NULL,
	[DetTaxSub00] [float] NOT NULL,
	[DetTaxSub01] [float] NOT NULL,
	[DetTaxSub02] [float] NOT NULL,
	[DetTaxSub03] [float] NOT NULL,
	[DetTotTax] [float] NOT NULL,
	[DetTxblAmt00] [float] NOT NULL,
	[DetTxblAmt01] [float] NOT NULL,
	[DetTxblAmt02] [float] NOT NULL,
	[DetTxblAmt03] [float] NOT NULL,
	[DetTxblSub00] [float] NOT NULL,
	[DetTxblSub01] [float] NOT NULL,
	[DetTxblSub02] [float] NOT NULL,
	[DetTxblSub03] [float] NOT NULL,
	[DisplayFlags] [smallint] NOT NULL,
	[DocTaxCntr00] [smallint] NOT NULL,
	[DocTaxCntr01] [smallint] NOT NULL,
	[DocTaxCntr02] [smallint] NOT NULL,
	[DocTaxCntr03] [smallint] NOT NULL,
	[DocTaxFrt00] [float] NOT NULL,
	[DocTaxFrt01] [float] NOT NULL,
	[DocTaxFrt02] [float] NOT NULL,
	[DocTaxFrt03] [float] NOT NULL,
	[DocTaxID00] [char](10) NOT NULL,
	[DocTaxID01] [char](10) NOT NULL,
	[DocTaxID02] [char](10) NOT NULL,
	[DocTaxID03] [char](10) NOT NULL,
	[DocTaxMisc00] [float] NOT NULL,
	[DocTaxMisc01] [float] NOT NULL,
	[DocTaxMisc02] [float] NOT NULL,
	[DocTaxMisc03] [float] NOT NULL,
	[DocTaxTot00] [float] NOT NULL,
	[DocTaxTot01] [float] NOT NULL,
	[DocTaxTot02] [float] NOT NULL,
	[DocTaxTot03] [float] NOT NULL,
	[DocTotal] [float] NOT NULL,
	[DocTotTax] [float] NOT NULL,
	[DocTxblFrt00] [float] NOT NULL,
	[DocTxblFrt01] [float] NOT NULL,
	[DocTxblFrt02] [float] NOT NULL,
	[DocTxblFrt03] [float] NOT NULL,
	[DocTxblMisc00] [float] NOT NULL,
	[DocTxblMisc01] [float] NOT NULL,
	[DocTxblMisc02] [float] NOT NULL,
	[DocTxblMisc03] [float] NOT NULL,
	[DocTxblTot00] [float] NOT NULL,
	[DocTxblTot01] [float] NOT NULL,
	[DocTxblTot02] [float] NOT NULL,
	[DocTxblTot03] [float] NOT NULL,
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
	[TaxCalced] [char](1) NOT NULL,
	[TaxDate] [smalldatetime] NOT NULL,
	[TaxIdDflt] [char](10) NOT NULL,
	[TermsDiscPct] [float] NOT NULL,
	[TradeDiscPct] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetCostAmt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetExtAmt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTaxSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDetTxblSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTaxTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTotal]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryDocTxblTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryFreight]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryMiscChrg]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [CuryTaxBasisAmt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetLineID]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DetLineRef]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetQty]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetRowNbr]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DetTaxCat]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DetTaxID00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DetTaxID01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DetTaxID02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DetTaxID03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTaxSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DetTxblSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DisplayFlags]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxCntr00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxCntr01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxCntr02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxCntr03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DocTaxID00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DocTaxID01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DocTaxID02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [DocTaxID03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTaxTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTotal]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [DocTxblTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [TaxCalced]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ('01/01/1900') FOR [TaxDate]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [TaxIdDflt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [TermsDiscPct]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [TradeDiscPct]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
