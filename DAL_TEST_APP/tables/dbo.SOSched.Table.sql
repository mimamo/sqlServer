USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[SOSched]    Script Date: 12/21/2015 13:56:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOSched](
	[AutoPO] [smallint] NOT NULL,
	[AutoPOVendID] [char](15) NOT NULL,
	[BlktOrdQty] [float] NOT NULL,
	[BlktOrdSchedRef] [char](5) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryTaxAmt00] [float] NOT NULL,
	[CuryTaxAmt01] [float] NOT NULL,
	[CuryTaxAmt02] [float] NOT NULL,
	[CuryTaxAmt03] [float] NOT NULL,
	[CuryTxblAmt00] [float] NOT NULL,
	[CuryTxblAmt01] [float] NOT NULL,
	[CuryTxblAmt02] [float] NOT NULL,
	[CuryTxblAmt03] [float] NOT NULL,
	[DropShip] [smallint] NOT NULL,
	[FrtCollect] [smallint] NOT NULL,
	[Hold] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerCntr] [smallint] NOT NULL,
	[LotSerialEntered] [smallint] NOT NULL,
	[LotSerialReq] [smallint] NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MarkFor] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[PremFrt] [smallint] NOT NULL,
	[PriorityDate] [smalldatetime] NOT NULL,
	[PrioritySeq] [int] NOT NULL,
	[PriorityTime] [smalldatetime] NOT NULL,
	[PromDate] [smalldatetime] NOT NULL,
	[QtyCloseShip] [float] NOT NULL,
	[QtyOpenShip] [float] NOT NULL,
	[QtyOrd] [float] NOT NULL,
	[QtyShip] [float] NOT NULL,
	[QtyToInvc] [float] NOT NULL,
	[ReqDate] [smalldatetime] NOT NULL,
	[ReqPickDate] [smalldatetime] NOT NULL,
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
	[SchedRef] [char](5) NOT NULL,
	[ShipAddrID] [char](10) NOT NULL,
	[ShipCustID] [char](15) NOT NULL,
	[ShipDate] [smalldatetime] NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipNow] [smallint] NOT NULL,
	[ShipSiteID] [char](10) NOT NULL,
	[ShiptoID] [char](10) NOT NULL,
	[ShiptoType] [char](1) NOT NULL,
	[ShipVendID] [char](15) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxAmt00] [float] NOT NULL,
	[TaxAmt01] [float] NOT NULL,
	[TaxAmt02] [float] NOT NULL,
	[TaxAmt03] [float] NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TaxIDDflt] [char](10) NOT NULL,
	[TransitTime] [smallint] NOT NULL,
	[TxblAmt00] [float] NOT NULL,
	[TxblAmt01] [float] NOT NULL,
	[TxblAmt02] [float] NOT NULL,
	[TxblAmt03] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[VendAddrID] [char](10) NOT NULL,
	[WeekendDelivery] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_AutoPO]  DEFAULT ((0)) FOR [AutoPO]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_AutoPOVendID]  DEFAULT (' ') FOR [AutoPOVendID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_BlktOrdQty]  DEFAULT ((0)) FOR [BlktOrdQty]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_BlktOrdSchedRef]  DEFAULT (' ') FOR [BlktOrdSchedRef]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTaxAmt00]  DEFAULT ((0)) FOR [CuryTaxAmt00]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTaxAmt01]  DEFAULT ((0)) FOR [CuryTaxAmt01]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTaxAmt02]  DEFAULT ((0)) FOR [CuryTaxAmt02]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTaxAmt03]  DEFAULT ((0)) FOR [CuryTaxAmt03]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTxblAmt00]  DEFAULT ((0)) FOR [CuryTxblAmt00]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTxblAmt01]  DEFAULT ((0)) FOR [CuryTxblAmt01]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTxblAmt02]  DEFAULT ((0)) FOR [CuryTxblAmt02]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_CuryTxblAmt03]  DEFAULT ((0)) FOR [CuryTxblAmt03]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_DropShip]  DEFAULT ((0)) FOR [DropShip]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_FrtCollect]  DEFAULT ((0)) FOR [FrtCollect]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_Hold]  DEFAULT ((0)) FOR [Hold]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LotSerCntr]  DEFAULT ((0)) FOR [LotSerCntr]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LotSerialEntered]  DEFAULT ((0)) FOR [LotSerialEntered]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LotSerialReq]  DEFAULT ((0)) FOR [LotSerialReq]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LotSerNbr]  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_MarkFor]  DEFAULT ((0)) FOR [MarkFor]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_PremFrt]  DEFAULT ((0)) FOR [PremFrt]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_PriorityDate]  DEFAULT ('01/01/1900') FOR [PriorityDate]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_PrioritySeq]  DEFAULT ((0)) FOR [PrioritySeq]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_PriorityTime]  DEFAULT ('01/01/1900') FOR [PriorityTime]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_PromDate]  DEFAULT ('01/01/1900') FOR [PromDate]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_QtyCloseShip]  DEFAULT ((0)) FOR [QtyCloseShip]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_QtyOpenShip]  DEFAULT ((0)) FOR [QtyOpenShip]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_QtyOrd]  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_QtyShip]  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_QtyToInvc]  DEFAULT ((0)) FOR [QtyToInvc]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ReqDate]  DEFAULT ('01/01/1900') FOR [ReqDate]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ReqPickDate]  DEFAULT ('01/01/1900') FOR [ReqPickDate]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_SchedRef]  DEFAULT (' ') FOR [SchedRef]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipAddrID]  DEFAULT (' ') FOR [ShipAddrID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipCustID]  DEFAULT (' ') FOR [ShipCustID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipDate]  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipName]  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipNow]  DEFAULT ((0)) FOR [ShipNow]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipSiteID]  DEFAULT (' ') FOR [ShipSiteID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShiptoID]  DEFAULT (' ') FOR [ShiptoID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShiptoType]  DEFAULT (' ') FOR [ShiptoType]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipVendID]  DEFAULT (' ') FOR [ShipVendID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipViaID]  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_ShipZip]  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxAmt00]  DEFAULT ((0)) FOR [TaxAmt00]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxAmt01]  DEFAULT ((0)) FOR [TaxAmt01]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxAmt02]  DEFAULT ((0)) FOR [TaxAmt02]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxAmt03]  DEFAULT ((0)) FOR [TaxAmt03]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxCat]  DEFAULT (' ') FOR [TaxCat]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxID00]  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxID01]  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxID02]  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxID03]  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TaxIDDflt]  DEFAULT (' ') FOR [TaxIDDflt]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TransitTime]  DEFAULT ((0)) FOR [TransitTime]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TxblAmt00]  DEFAULT ((0)) FOR [TxblAmt00]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TxblAmt01]  DEFAULT ((0)) FOR [TxblAmt01]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TxblAmt02]  DEFAULT ((0)) FOR [TxblAmt02]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_TxblAmt03]  DEFAULT ((0)) FOR [TxblAmt03]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_VendAddrID]  DEFAULT (' ') FOR [VendAddrID]
GO
ALTER TABLE [dbo].[SOSched] ADD  CONSTRAINT [DF_SOSched_WeekendDelivery]  DEFAULT ((0)) FOR [WeekendDelivery]
GO
