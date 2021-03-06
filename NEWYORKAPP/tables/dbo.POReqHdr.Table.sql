USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[POReqHdr]    Script Date: 12/21/2015 16:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POReqHdr](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[AppvLevObt] [char](2) NOT NULL,
	[AppvLevReq] [char](2) NOT NULL,
	[AppvProjectID] [char](16) NOT NULL,
	[AppvRouting] [char](1) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[BillAddr1] [char](60) NOT NULL,
	[BillAddr2] [char](60) NOT NULL,
	[BillAttn] [char](30) NOT NULL,
	[BillCity] [char](30) NOT NULL,
	[BillCountry] [char](3) NOT NULL,
	[BillEmail] [char](80) NOT NULL,
	[BillFax] [char](30) NOT NULL,
	[BillName] [char](60) NOT NULL,
	[BillPhone] [char](30) NOT NULL,
	[BillState] [char](3) NOT NULL,
	[BillZip] [char](10) NOT NULL,
	[BlktExpDate] [smalldatetime] NOT NULL,
	[BlktNbr] [char](10) NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[CertCompl] [smallint] NOT NULL,
	[City] [char](30) NOT NULL,
	[ConfirmTo] [char](10) NOT NULL,
	[COPrinted] [smallint] NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryFreight] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPrevPOTotal] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryReqTotal] [float] NOT NULL,
	[CuryTaxTot00] [float] NOT NULL,
	[CuryTaxTot01] [float] NOT NULL,
	[CuryTaxTot02] [float] NOT NULL,
	[CuryTaxTot03] [float] NOT NULL,
	[CuryTotalExtCost] [float] NOT NULL,
	[CuryTxblTot00] [float] NOT NULL,
	[CuryTxblTot01] [float] NOT NULL,
	[CuryTxblTot02] [float] NOT NULL,
	[CuryTxblTot03] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DocHandling] [char](2) NOT NULL,
	[EMail] [char](80) NOT NULL,
	[EncumbranceFlag] [char](1) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[FOB] [char](15) NOT NULL,
	[Freight] [float] NOT NULL,
	[LineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OptA] [char](1) NOT NULL,
	[OptB] [char](1) NOT NULL,
	[OptC] [char](1) NOT NULL,
	[PerApproved] [char](6) NOT NULL,
	[PerEntered] [char](6) NOT NULL,
	[Phone] [char](30) NOT NULL,
	[PODate] [smalldatetime] NOT NULL,
	[PolicyLevObt] [char](2) NOT NULL,
	[PolicyLevReq] [char](2) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[POPrinted] [smallint] NOT NULL,
	[POType] [char](2) NOT NULL,
	[PrevPOTotal] [float] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[QuoteDate] [smalldatetime] NOT NULL,
	[ReqCntr] [char](2) NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
	[ReqTotal] [float] NOT NULL,
	[ReqType] [char](2) NOT NULL,
	[Requstnr] [char](47) NOT NULL,
	[RequstnrDept] [char](10) NOT NULL,
	[RequstnrName] [char](30) NOT NULL,
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
	[ShipAddr1] [char](60) NOT NULL,
	[ShipAddr2] [char](60) NOT NULL,
	[ShipAddrID] [char](10) NOT NULL,
	[ShipAttn] [char](30) NOT NULL,
	[ShipCity] [char](30) NOT NULL,
	[ShipCountry] [char](3) NOT NULL,
	[ShipEmail] [char](80) NOT NULL,
	[ShipFax] [char](30) NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipPhone] [char](30) NOT NULL,
	[ShipState] [char](3) NOT NULL,
	[ShipVia] [char](15) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[State] [char](3) NOT NULL,
	[Status] [char](2) NOT NULL,
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
	[TotalExtCost] [float] NOT NULL,
	[TranMedium] [char](2) NOT NULL,
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
	[VendAddrID] [char](10) NOT NULL,
	[VendID] [char](15) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [AppvLevObt]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [AppvLevReq]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [AppvProjectID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [AppvRouting]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Attn]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillAddr1]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillAddr2]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillAttn]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillCity]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillCountry]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillEmail]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillFax]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillName]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillPhone]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillState]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BillZip]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [BlktExpDate]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [BlktNbr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CertCompl]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ConfirmTo]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [COPrinted]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [CreateDate]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryFreight]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryPrevPOTotal]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryReqTotal]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTaxTot00]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTaxTot01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTaxTot02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTaxTot03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTotalExtCost]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTxblTot00]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTxblTot01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTxblTot02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [CuryTxblTot03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [DocHandling]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [EMail]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [EncumbranceFlag]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [FOB]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [Freight]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [OptA]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [OptB]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [OptC]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [PerApproved]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [PerEntered]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [PODate]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [PolicyLevObt]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [PolicyLevReq]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [POPrinted]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [POType]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [PrevPOTotal]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [QuoteDate]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ReqCntr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [ReqTotal]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ReqType]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Requstnr]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [RequstnrDept]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [RequstnrName]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipAddrID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipAttn]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipEmail]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipFax]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipPhone]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipVia]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxCntr00]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxCntr01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxCntr02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxCntr03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxTot00]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxTot01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxTot02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TaxTot03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Terms]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TotalExtCost]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [TranMedium]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TxblTot00]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TxblTot01]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TxblTot02]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [TxblTot03]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [VendAddrID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[POReqHdr] ADD  DEFAULT (' ') FOR [Zip]
GO
