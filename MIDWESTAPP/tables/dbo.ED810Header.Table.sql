USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[ED810Header]    Script Date: 12/21/2015 15:54:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED810Header](
	[BackOrderFlag] [smallint] NOT NULL,
	[BlktPONbr] [char](20) NOT NULL,
	[BOLNbr] [char](20) NOT NULL,
	[BuyerID] [char](10) NOT NULL,
	[BuyerName] [char](30) NOT NULL,
	[ChangeOrdNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurCode] [char](3) NOT NULL,
	[CuryDiscTot] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryFreightTot] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryInvcTot] [float] NOT NULL,
	[CuryMiscChargeTot] [float] NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryMultiDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTaxTot] [float] NOT NULL,
	[CuryTermsAmtSubjDisc] [float] NOT NULL,
	[CuryTermsDefAmtDue] [float] NOT NULL,
	[CuryTermsDiscAmt] [float] NOT NULL,
	[CuryTermsTotDisc] [float] NOT NULL,
	[DiscTot] [float] NOT NULL,
	[EDIInvID] [char](10) NOT NULL,
	[FOBDesc] [char](80) NOT NULL,
	[FOBLocQual] [char](2) NOT NULL,
	[FreightTot] [float] NOT NULL,
	[GSNbr] [int] NOT NULL,
	[GSRcvID] [char](15) NOT NULL,
	[GSSenderID] [char](15) NOT NULL,
	[HashTotal] [float] NOT NULL,
	[IntChgStandard] [char](1) NOT NULL,
	[IntChgTestFlag] [char](1) NOT NULL,
	[IntChgVersion] [char](5) NOT NULL,
	[IntVendNbr] [char](30) NOT NULL,
	[InvcDate] [smalldatetime] NOT NULL,
	[InvcNbr] [char](15) NOT NULL,
	[InvcTot] [float] NOT NULL,
	[IsaNbr] [int] NOT NULL,
	[IsaRcvID] [char](15) NOT NULL,
	[IsaRcvQual] [char](2) NOT NULL,
	[ISndID] [char](15) NOT NULL,
	[ISndQual] [char](2) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MiscChargeTot] [float] NOT NULL,
	[NbrContainer] [smallint] NOT NULL,
	[NbrLines] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrderVolume] [int] NOT NULL,
	[OrderVolumeUOM] [char](6) NOT NULL,
	[OrderWeight] [int] NOT NULL,
	[OrderWeightUOM] [char](6) NOT NULL,
	[PODate] [smalldatetime] NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[PRO] [char](20) NOT NULL,
	[ProjectDescr] [char](80) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ReleaseNbr] [char](30) NOT NULL,
	[Routing] [char](50) NOT NULL,
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
	[SCAC] [char](5) NOT NULL,
	[ShipMethPay] [char](2) NOT NULL,
	[Standard] [char](2) NOT NULL,
	[STNbr] [int] NOT NULL,
	[TaxTot] [float] NOT NULL,
	[TermsAmtSubjDisc] [float] NOT NULL,
	[TermsBasisCode] [char](2) NOT NULL,
	[TermsDayMonth] [smallint] NOT NULL,
	[TermsDefAmtDue] [float] NOT NULL,
	[TermsDefDueDate] [smalldatetime] NOT NULL,
	[TermsDesc] [char](80) NOT NULL,
	[TermsDiscAmt] [float] NOT NULL,
	[TermsDiscDaysDue] [smallint] NOT NULL,
	[TermsDiscDueDate] [smalldatetime] NOT NULL,
	[TermsDiscNetDueDate] [smalldatetime] NOT NULL,
	[TermsDiscPerc] [float] NOT NULL,
	[TermsID] [char](2) NOT NULL,
	[TermsNetDays] [smallint] NOT NULL,
	[TermsPayMethCode] [char](2) NOT NULL,
	[TermsPercPay] [float] NOT NULL,
	[TermsTotDisc] [float] NOT NULL,
	[TermsTypeCode] [char](3) NOT NULL,
	[TranMethCode] [char](3) NOT NULL,
	[TransmitDate] [smalldatetime] NOT NULL,
	[TransmitTime] [char](8) NOT NULL,
	[UpdateStatus] [char](2) NOT NULL,
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
	[VendID] [char](15) NOT NULL,
	[Version] [char](12) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [BackOrderFlag]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [BlktPONbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [BOLNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [BuyerID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [BuyerName]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ChangeOrdNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [CurCode]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryDiscTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryFreightTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryInvcTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryMiscChargeTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [CuryMultiDiv]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryTaxTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryTermsAmtSubjDisc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryTermsDefAmtDue]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryTermsDiscAmt]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [CuryTermsTotDisc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [DiscTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [EDIInvID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [FOBDesc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [FreightTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [GSNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [GSRcvID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [GSSenderID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [HashTotal]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [IntChgStandard]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [IntChgTestFlag]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [IntChgVersion]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [IntVendNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [InvcDate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [InvcTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [IsaNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [IsaRcvID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [IsaRcvQual]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ISndID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ISndQual]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [MiscChargeTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [NbrContainer]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [NbrLines]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [OrderVolume]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [OrderVolumeUOM]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [OrderWeight]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [OrderWeightUOM]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [PODate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [PRO]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ProjectDescr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ReleaseNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Routing]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [SCAC]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [ShipMethPay]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Standard]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [STNbr]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TaxTot]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsAmtSubjDisc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TermsBasisCode]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsDayMonth]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsDefAmtDue]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [TermsDefDueDate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TermsDesc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsDiscAmt]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsDiscDaysDue]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [TermsDiscDueDate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [TermsDiscNetDueDate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsDiscPerc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TermsID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsNetDays]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TermsPayMethCode]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsPercPay]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [TermsTotDisc]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TermsTypeCode]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TranMethCode]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [TransmitDate]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [TransmitTime]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [UpdateStatus]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[ED810Header] ADD  DEFAULT (' ') FOR [Version]
GO
