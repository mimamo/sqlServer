USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[TaxCalc]    Script Date: 12/21/2015 14:05:28 ******/
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
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetCostAmt]  DEFAULT ((0)) FOR [CuryDetCostAmt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetExtAmt]  DEFAULT ((0)) FOR [CuryDetExtAmt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxAmt00]  DEFAULT ((0)) FOR [CuryDetTaxAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxAmt01]  DEFAULT ((0)) FOR [CuryDetTaxAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxAmt02]  DEFAULT ((0)) FOR [CuryDetTaxAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxAmt03]  DEFAULT ((0)) FOR [CuryDetTaxAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxSub00]  DEFAULT ((0)) FOR [CuryDetTaxSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxSub01]  DEFAULT ((0)) FOR [CuryDetTaxSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxSub02]  DEFAULT ((0)) FOR [CuryDetTaxSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTaxSub03]  DEFAULT ((0)) FOR [CuryDetTaxSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTotTax]  DEFAULT ((0)) FOR [CuryDetTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblAmt00]  DEFAULT ((0)) FOR [CuryDetTxblAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblAmt01]  DEFAULT ((0)) FOR [CuryDetTxblAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblAmt02]  DEFAULT ((0)) FOR [CuryDetTxblAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblAmt03]  DEFAULT ((0)) FOR [CuryDetTxblAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblSub00]  DEFAULT ((0)) FOR [CuryDetTxblSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblSub01]  DEFAULT ((0)) FOR [CuryDetTxblSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblSub02]  DEFAULT ((0)) FOR [CuryDetTxblSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDetTxblSub03]  DEFAULT ((0)) FOR [CuryDetTxblSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxFrt00]  DEFAULT ((0)) FOR [CuryDocTaxFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxFrt01]  DEFAULT ((0)) FOR [CuryDocTaxFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxFrt02]  DEFAULT ((0)) FOR [CuryDocTaxFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxFrt03]  DEFAULT ((0)) FOR [CuryDocTaxFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxMisc00]  DEFAULT ((0)) FOR [CuryDocTaxMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxMisc01]  DEFAULT ((0)) FOR [CuryDocTaxMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxMisc02]  DEFAULT ((0)) FOR [CuryDocTaxMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxMisc03]  DEFAULT ((0)) FOR [CuryDocTaxMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxTot00]  DEFAULT ((0)) FOR [CuryDocTaxTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxTot01]  DEFAULT ((0)) FOR [CuryDocTaxTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxTot02]  DEFAULT ((0)) FOR [CuryDocTaxTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTaxTot03]  DEFAULT ((0)) FOR [CuryDocTaxTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTotal]  DEFAULT ((0)) FOR [CuryDocTotal]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTotTax]  DEFAULT ((0)) FOR [CuryDocTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblFrt00]  DEFAULT ((0)) FOR [CuryDocTxblFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblFrt01]  DEFAULT ((0)) FOR [CuryDocTxblFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblFrt02]  DEFAULT ((0)) FOR [CuryDocTxblFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblFrt03]  DEFAULT ((0)) FOR [CuryDocTxblFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblMisc00]  DEFAULT ((0)) FOR [CuryDocTxblMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblMisc01]  DEFAULT ((0)) FOR [CuryDocTxblMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblMisc02]  DEFAULT ((0)) FOR [CuryDocTxblMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblMisc03]  DEFAULT ((0)) FOR [CuryDocTxblMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblTot00]  DEFAULT ((0)) FOR [CuryDocTxblTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblTot01]  DEFAULT ((0)) FOR [CuryDocTxblTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblTot02]  DEFAULT ((0)) FOR [CuryDocTxblTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryDocTxblTot03]  DEFAULT ((0)) FOR [CuryDocTxblTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryFreight]  DEFAULT ((0)) FOR [CuryFreight]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryMiscChrg]  DEFAULT ((0)) FOR [CuryMiscChrg]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_CuryTaxBasisAmt]  DEFAULT ((0)) FOR [CuryTaxBasisAmt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetLineID]  DEFAULT ((0)) FOR [DetLineID]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetLineRef]  DEFAULT (' ') FOR [DetLineRef]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetQty]  DEFAULT ((0)) FOR [DetQty]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetRowNbr]  DEFAULT ((0)) FOR [DetRowNbr]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxAmt00]  DEFAULT ((0)) FOR [DetTaxAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxAmt01]  DEFAULT ((0)) FOR [DetTaxAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxAmt02]  DEFAULT ((0)) FOR [DetTaxAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxAmt03]  DEFAULT ((0)) FOR [DetTaxAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxCat]  DEFAULT (' ') FOR [DetTaxCat]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxID00]  DEFAULT (' ') FOR [DetTaxID00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxID01]  DEFAULT (' ') FOR [DetTaxID01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxID02]  DEFAULT (' ') FOR [DetTaxID02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxID03]  DEFAULT (' ') FOR [DetTaxID03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxSub00]  DEFAULT ((0)) FOR [DetTaxSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxSub01]  DEFAULT ((0)) FOR [DetTaxSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxSub02]  DEFAULT ((0)) FOR [DetTaxSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTaxSub03]  DEFAULT ((0)) FOR [DetTaxSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTotTax]  DEFAULT ((0)) FOR [DetTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblAmt00]  DEFAULT ((0)) FOR [DetTxblAmt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblAmt01]  DEFAULT ((0)) FOR [DetTxblAmt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblAmt02]  DEFAULT ((0)) FOR [DetTxblAmt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblAmt03]  DEFAULT ((0)) FOR [DetTxblAmt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblSub00]  DEFAULT ((0)) FOR [DetTxblSub00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblSub01]  DEFAULT ((0)) FOR [DetTxblSub01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblSub02]  DEFAULT ((0)) FOR [DetTxblSub02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DetTxblSub03]  DEFAULT ((0)) FOR [DetTxblSub03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DisplayFlags]  DEFAULT ((0)) FOR [DisplayFlags]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxCntr00]  DEFAULT ((0)) FOR [DocTaxCntr00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxCntr01]  DEFAULT ((0)) FOR [DocTaxCntr01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxCntr02]  DEFAULT ((0)) FOR [DocTaxCntr02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxCntr03]  DEFAULT ((0)) FOR [DocTaxCntr03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxFrt00]  DEFAULT ((0)) FOR [DocTaxFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxFrt01]  DEFAULT ((0)) FOR [DocTaxFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxFrt02]  DEFAULT ((0)) FOR [DocTaxFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxFrt03]  DEFAULT ((0)) FOR [DocTaxFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxID00]  DEFAULT (' ') FOR [DocTaxID00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxID01]  DEFAULT (' ') FOR [DocTaxID01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxID02]  DEFAULT (' ') FOR [DocTaxID02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxID03]  DEFAULT (' ') FOR [DocTaxID03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxMisc00]  DEFAULT ((0)) FOR [DocTaxMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxMisc01]  DEFAULT ((0)) FOR [DocTaxMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxMisc02]  DEFAULT ((0)) FOR [DocTaxMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxMisc03]  DEFAULT ((0)) FOR [DocTaxMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxTot00]  DEFAULT ((0)) FOR [DocTaxTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxTot01]  DEFAULT ((0)) FOR [DocTaxTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxTot02]  DEFAULT ((0)) FOR [DocTaxTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTaxTot03]  DEFAULT ((0)) FOR [DocTaxTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTotal]  DEFAULT ((0)) FOR [DocTotal]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTotTax]  DEFAULT ((0)) FOR [DocTotTax]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblFrt00]  DEFAULT ((0)) FOR [DocTxblFrt00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblFrt01]  DEFAULT ((0)) FOR [DocTxblFrt01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblFrt02]  DEFAULT ((0)) FOR [DocTxblFrt02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblFrt03]  DEFAULT ((0)) FOR [DocTxblFrt03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblMisc00]  DEFAULT ((0)) FOR [DocTxblMisc00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblMisc01]  DEFAULT ((0)) FOR [DocTxblMisc01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblMisc02]  DEFAULT ((0)) FOR [DocTxblMisc02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblMisc03]  DEFAULT ((0)) FOR [DocTxblMisc03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblTot00]  DEFAULT ((0)) FOR [DocTxblTot00]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblTot01]  DEFAULT ((0)) FOR [DocTxblTot01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblTot02]  DEFAULT ((0)) FOR [DocTxblTot02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_DocTxblTot03]  DEFAULT ((0)) FOR [DocTxblTot03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_TaxCalced]  DEFAULT (' ') FOR [TaxCalced]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_TaxDate]  DEFAULT ('01/01/1900') FOR [TaxDate]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_TaxIdDflt]  DEFAULT (' ') FOR [TaxIdDflt]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_TermsDiscPct]  DEFAULT ((0)) FOR [TermsDiscPct]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_TradeDiscPct]  DEFAULT ((0)) FOR [TradeDiscPct]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[TaxCalc] ADD  CONSTRAINT [DF_TaxCalc_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
