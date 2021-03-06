USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[POSetup]    Script Date: 12/21/2015 13:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POSetup](
	[AddAlternateID] [char](1) NOT NULL,
	[AdminLeadTime] [smallint] NOT NULL,
	[APAccrAcct] [char](10) NOT NULL,
	[APAccrSub] [char](24) NOT NULL,
	[AutoRef] [smallint] NOT NULL,
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
	[CreateAD] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DecPlPrcCst] [smallint] NOT NULL,
	[DecPlQty] [smallint] NOT NULL,
	[DefaultAltIDType] [char](1) NOT NULL,
	[DemandPeriods] [smallint] NOT NULL,
	[DfltLstUnitCost] [char](1) NOT NULL,
	[DfltRcptUnitFromIN] [smallint] NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtSub] [char](24) NOT NULL,
	[HotPrintPO] [smallint] NOT NULL,
	[INAvail] [smallint] NOT NULL,
	[Init] [smallint] NOT NULL,
	[InvtCarryingCost] [float] NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LastPONbr] [char](10) NOT NULL,
	[LastRcptNbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MultPOAllowed] [smallint] NOT NULL,
	[NonInvtAcct] [char](10) NOT NULL,
	[NonInvtSub] [char](24) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PCAvail] [smallint] NOT NULL,
	[PerRetTran] [smallint] NOT NULL,
	[PMAvail] [smallint] NOT NULL,
	[PPVAcct] [char](10) NOT NULL,
	[PPVSub] [char](24) NOT NULL,
	[PrtAddr] [smallint] NOT NULL,
	[PrtSite] [smallint] NOT NULL,
	[ReopenPO] [smallint] NOT NULL,
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
	[SetupCost] [float] NOT NULL,
	[SetupID] [char](2) NOT NULL,
	[ShipAddr1] [char](60) NOT NULL,
	[ShipAddr2] [char](60) NOT NULL,
	[ShipAttn] [char](30) NOT NULL,
	[ShipCity] [char](30) NOT NULL,
	[ShipCountry] [char](3) NOT NULL,
	[ShipEmail] [char](80) NOT NULL,
	[ShipFax] [char](30) NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipPhone] [char](30) NOT NULL,
	[ShipState] [char](3) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[TaxFlg] [smallint] NOT NULL,
	[TranDescFlg] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Vouchering] [smallint] NOT NULL,
	[VouchQtyErr] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_AddAlternateID]  DEFAULT (' ') FOR [AddAlternateID]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_AdminLeadTime]  DEFAULT ((0)) FOR [AdminLeadTime]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_APAccrAcct]  DEFAULT (' ') FOR [APAccrAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_APAccrSub]  DEFAULT (' ') FOR [APAccrSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_AutoRef]  DEFAULT ((0)) FOR [AutoRef]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillAddr1]  DEFAULT (' ') FOR [BillAddr1]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillAddr2]  DEFAULT (' ') FOR [BillAddr2]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillAttn]  DEFAULT (' ') FOR [BillAttn]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillCity]  DEFAULT (' ') FOR [BillCity]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillCountry]  DEFAULT (' ') FOR [BillCountry]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillEmail]  DEFAULT (' ') FOR [BillEmail]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillFax]  DEFAULT (' ') FOR [BillFax]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillName]  DEFAULT (' ') FOR [BillName]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillPhone]  DEFAULT (' ') FOR [BillPhone]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillState]  DEFAULT (' ') FOR [BillState]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_BillZip]  DEFAULT (' ') FOR [BillZip]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_CreateAD]  DEFAULT ((0)) FOR [CreateAD]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_DecPlPrcCst]  DEFAULT ((0)) FOR [DecPlPrcCst]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_DecPlQty]  DEFAULT ((0)) FOR [DecPlQty]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_DefaultAltIDType]  DEFAULT (' ') FOR [DefaultAltIDType]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_DemandPeriods]  DEFAULT ((0)) FOR [DemandPeriods]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_DfltLstUnitCost]  DEFAULT (' ') FOR [DfltLstUnitCost]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_DfltRcptUnitFromIN]  DEFAULT ((0)) FOR [DfltRcptUnitFromIN]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_FrtAcct]  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_FrtSub]  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_HotPrintPO]  DEFAULT ((0)) FOR [HotPrintPO]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_INAvail]  DEFAULT ((0)) FOR [INAvail]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_Init]  DEFAULT ((0)) FOR [Init]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_InvtCarryingCost]  DEFAULT ((0)) FOR [InvtCarryingCost]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_LastBatNbr]  DEFAULT (' ') FOR [LastBatNbr]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_LastPONbr]  DEFAULT (' ') FOR [LastPONbr]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_LastRcptNbr]  DEFAULT (' ') FOR [LastRcptNbr]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_MultPOAllowed]  DEFAULT ((0)) FOR [MultPOAllowed]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_NonInvtAcct]  DEFAULT (' ') FOR [NonInvtAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_NonInvtSub]  DEFAULT (' ') FOR [NonInvtSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PCAvail]  DEFAULT ((0)) FOR [PCAvail]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PerRetTran]  DEFAULT ((0)) FOR [PerRetTran]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PMAvail]  DEFAULT ((0)) FOR [PMAvail]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PPVAcct]  DEFAULT (' ') FOR [PPVAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PPVSub]  DEFAULT (' ') FOR [PPVSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PrtAddr]  DEFAULT ((0)) FOR [PrtAddr]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_PrtSite]  DEFAULT ((0)) FOR [PrtSite]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ReopenPO]  DEFAULT ((0)) FOR [ReopenPO]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_SetupCost]  DEFAULT ((0)) FOR [SetupCost]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_SetupID]  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipAddr1]  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipAddr2]  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipAttn]  DEFAULT (' ') FOR [ShipAttn]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipCity]  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipCountry]  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipEmail]  DEFAULT (' ') FOR [ShipEmail]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipFax]  DEFAULT (' ') FOR [ShipFax]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipName]  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipPhone]  DEFAULT (' ') FOR [ShipPhone]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipState]  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_ShipZip]  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_TaxFlg]  DEFAULT ((0)) FOR [TaxFlg]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_TranDescFlg]  DEFAULT (' ') FOR [TranDescFlg]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_Vouchering]  DEFAULT ((0)) FOR [Vouchering]
GO
ALTER TABLE [dbo].[POSetup] ADD  CONSTRAINT [DF_POSetup_VouchQtyErr]  DEFAULT (' ') FOR [VouchQtyErr]
GO
