USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[POSetup]    Script Date: 12/21/2015 14:26:36 ******/
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
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [AddAlternateID]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [AdminLeadTime]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [APAccrAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [APAccrSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [AutoRef]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillAddr1]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillAddr2]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillAttn]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillCity]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillCountry]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillEmail]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillFax]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillName]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillPhone]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillState]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [BillZip]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [CreateAD]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [DecPlPrcCst]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [DecPlQty]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [DefaultAltIDType]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [DemandPeriods]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [DfltLstUnitCost]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [DfltRcptUnitFromIN]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [HotPrintPO]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [INAvail]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [Init]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [InvtCarryingCost]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [LastBatNbr]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [LastPONbr]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [LastRcptNbr]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [MultPOAllowed]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [NonInvtAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [NonInvtSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [PCAvail]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [PerRetTran]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [PMAvail]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [PPVAcct]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [PPVSub]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [PrtAddr]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [PrtSite]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [ReopenPO]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [SetupCost]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipAttn]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipEmail]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipFax]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipPhone]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [TaxFlg]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [TranDescFlg]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT ((0)) FOR [Vouchering]
GO
ALTER TABLE [dbo].[POSetup] ADD  DEFAULT (' ') FOR [VouchQtyErr]
GO
