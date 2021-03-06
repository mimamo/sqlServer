USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PurchOrd]    Script Date: 12/21/2015 16:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PurchOrd](
	[AckDateTime] [smalldatetime] NOT NULL,
	[ASID] [int] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BillShipAddr] [smallint] NOT NULL,
	[BlktExprDate] [smalldatetime] NOT NULL,
	[BlktPONbr] [char](10) NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[CertCompl] [smallint] NOT NULL,
	[ConfirmTo] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrentNbr] [smallint] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryFreight] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPOAmt] [float] NOT NULL,
	[CuryPOItemTotal] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryRcptTotAmt] [float] NOT NULL,
	[CuryTaxTot00] [float] NOT NULL,
	[CuryTaxTot01] [float] NOT NULL,
	[CuryTaxTot02] [float] NOT NULL,
	[CuryTaxTot03] [float] NOT NULL,
	[CuryTxblTot00] [float] NOT NULL,
	[CuryTxblTot01] [float] NOT NULL,
	[CuryTxblTot02] [float] NOT NULL,
	[CuryTxblTot03] [float] NOT NULL,
	[EDI] [smallint] NOT NULL,
	[FOB] [char](15) NOT NULL,
	[Freight] [float] NOT NULL,
	[LastRcptDate] [smalldatetime] NOT NULL,
	[LineCntr] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenPO] [smallint] NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[POAmt] [float] NOT NULL,
	[PODate] [smalldatetime] NOT NULL,
	[POItemTotal] [float] NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[POType] [char](2) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[PrtBatNbr] [char](10) NOT NULL,
	[PrtFlg] [smallint] NOT NULL,
	[RcptStage] [char](1) NOT NULL,
	[RcptTotAmt] [float] NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
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
	[ServiceCallID] [char](10) NOT NULL,
	[ShipAddr1] [char](60) NOT NULL,
	[ShipAddr2] [char](60) NOT NULL,
	[ShipAddrID] [char](10) NOT NULL,
	[ShipAttn] [char](30) NOT NULL,
	[ShipCity] [char](30) NOT NULL,
	[ShipCountry] [char](3) NOT NULL,
	[ShipCustID] [char](15) NOT NULL,
	[ShipEmail] [char](80) NOT NULL,
	[ShipFax] [char](30) NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipPhone] [char](30) NOT NULL,
	[ShipSiteID] [char](10) NOT NULL,
	[ShipState] [char](3) NOT NULL,
	[ShiptoID] [char](10) NOT NULL,
	[ShiptoType] [char](1) NOT NULL,
	[ShipVendAddrID] [char](10) NOT NULL,
	[ShipVendID] [char](15) NOT NULL,
	[ShipVia] [char](15) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxCntr00] [smallint] NOT NULL,
	[TaxCntr01] [smallint] NOT NULL,
	[TaxCntr02] [smallint] NOT NULL,
	[TaxCntr03] [smallint] NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TaxTot00] [float] NOT NULL,
	[TaxTot01] [float] NOT NULL,
	[TaxTot02] [float] NOT NULL,
	[TaxTot03] [float] NOT NULL,
	[Terms] [char](2) NOT NULL,
	[TxblTot00] [float] NOT NULL,
	[TxblTot01] [float] NOT NULL,
	[TxblTot02] [float] NOT NULL,
	[TxblTot03] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendAddr1] [char](60) NOT NULL,
	[VendAddr2] [char](60) NOT NULL,
	[VendAddrID] [char](10) NOT NULL,
	[VendAttn] [char](30) NOT NULL,
	[VendCity] [char](30) NOT NULL,
	[VendCountry] [char](3) NOT NULL,
	[VendEmail] [char](80) NOT NULL,
	[VendFax] [char](30) NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VendName] [char](60) NOT NULL,
	[VendPhone] [char](30) NOT NULL,
	[VendState] [char](3) NOT NULL,
	[VendZip] [char](10) NOT NULL,
	[VouchStage] [char](1) NOT NULL,
	[WSID] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [AckDateTime]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [ASID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [BillShipAddr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [BlktExprDate]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [BlktPONbr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CertCompl]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ConfirmTo]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CurrentNbr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryFreight]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryPOAmt]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryPOItemTotal]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryRcptTotAmt]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTaxTot00]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTaxTot01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTaxTot02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTaxTot03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTxblTot00]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTxblTot01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTxblTot02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [CuryTxblTot03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [EDI]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [FOB]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [Freight]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [LastRcptDate]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [OpenPO]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [POAmt]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [PODate]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [POItemTotal]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [POType]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [PrtBatNbr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [PrtFlg]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [RcptStage]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [RcptTotAmt]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ServiceCallID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipAddrID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipAttn]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipCustID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipEmail]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipFax]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipPhone]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipSiteID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShiptoID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShiptoType]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipVendAddrID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipVendID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipVia]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxCntr00]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxCntr01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxCntr02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxCntr03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxTot00]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxTot01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxTot02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TaxTot03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [Terms]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TxblTot00]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TxblTot01]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TxblTot02]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [TxblTot03]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendAddr1]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendAddr2]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendAddrID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendAttn]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendCity]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendCountry]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendEmail]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendFax]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendName]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendPhone]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendState]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VendZip]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT (' ') FOR [VouchStage]
GO
ALTER TABLE [dbo].[PurchOrd] ADD  DEFAULT ((0)) FOR [WSID]
GO
