USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[CustomerEDI]    Script Date: 12/21/2015 14:26:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerEDI](
	[AgreeNbrFlg] [smallint] NOT NULL,
	[ApptNbrFlg] [smallint] NOT NULL,
	[ArrivalDateFlg] [smallint] NOT NULL,
	[BatchNbrFlg] [smallint] NOT NULL,
	[BidNbrFlg] [smallint] NOT NULL,
	[BOLFlg] [smallint] NOT NULL,
	[BOLNoteID] [int] NOT NULL,
	[BOLRptFormat] [char](30) NOT NULL,
	[BuyerReqd] [smallint] NOT NULL,
	[CertID] [char](2) NOT NULL,
	[CheckShipToID] [smallint] NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](31) NOT NULL,
	[ContractNbrFlg] [smallint] NOT NULL,
	[ContTrackLevel] [char](10) NOT NULL,
	[CreditMgrID] [char](10) NOT NULL,
	[CreditRule] [char](2) NOT NULL,
	[CrossDockFlg] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustCommClassID] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustItemReqd] [smallint] NOT NULL,
	[DeliveryDateFlg] [smallint] NOT NULL,
	[DeptFlg] [smallint] NOT NULL,
	[DfltBuyerID] [char](10) NOT NULL,
	[DiscAcct] [char](10) NOT NULL,
	[DiscSub] [char](31) NOT NULL,
	[DivFlg] [smallint] NOT NULL,
	[EDSOUser10Flg] [smallint] NOT NULL,
	[EDSOUser1Flg] [smallint] NOT NULL,
	[EDSOUser2Flg] [smallint] NOT NULL,
	[EDSOUser3Flg] [smallint] NOT NULL,
	[EDSOUser4Flg] [smallint] NOT NULL,
	[EDSOUser5Flg] [smallint] NOT NULL,
	[EDSOUser6Flg] [smallint] NOT NULL,
	[EDSOUser7Flg] [smallint] NOT NULL,
	[EDSOUser8Flg] [smallint] NOT NULL,
	[EDSOUser9Flg] [smallint] NOT NULL,
	[EquipNbrFlg] [smallint] NOT NULL,
	[FOBFlg] [smallint] NOT NULL,
	[FOBID] [char](15) NOT NULL,
	[FOBLocQualFlg] [smallint] NOT NULL,
	[FOBTranTypeFlg] [smallint] NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtAllowCd] [char](30) NOT NULL,
	[FrtDiscCd] [char](30) NOT NULL,
	[FrtSub] [char](31) NOT NULL,
	[GeoCode] [char](10) NOT NULL,
	[GLClassID] [char](4) NOT NULL,
	[GracePer] [smallint] NOT NULL,
	[GSA] [smallint] NOT NULL,
	[HeightFlg] [smallint] NOT NULL,
	[ImpConvMeth] [char](2) NOT NULL,
	[InternalNoteID] [int] NOT NULL,
	[IntVendorNbr] [char](30) NOT NULL,
	[IntVendorNbrFlg] [smallint] NOT NULL,
	[InvcNoteID] [int] NOT NULL,
	[LabelReqd] [smallint] NOT NULL,
	[LenFlg] [smallint] NOT NULL,
	[LineItemEDIDiscCode] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MajorAccount] [char](15) NOT NULL,
	[ManNoteID] [int] NOT NULL,
	[MinOrder] [float] NOT NULL,
	[MinWt] [float] NOT NULL,
	[MiscAcct] [char](10) NOT NULL,
	[MiscSub] [char](31) NOT NULL,
	[MultiDestMeth] [char](3) NOT NULL,
	[NbrCartonsFlg] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigSourceID] [char](10) NOT NULL,
	[OutBndTemplate] [char](20) NOT NULL,
	[PlanDateFlg] [smallint] NOT NULL,
	[POReqd] [smallint] NOT NULL,
	[PROFlg] [smallint] NOT NULL,
	[PromoNbrFlg] [smallint] NOT NULL,
	[PSNoteID] [int] NOT NULL,
	[PTNoteID] [int] NOT NULL,
	[QuoteNbrFlg] [smallint] NOT NULL,
	[RegionID] [char](10) NOT NULL,
	[RequestDateFlg] [smallint] NOT NULL,
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
	[SalespersonFlg] [smallint] NOT NULL,
	[SalesRegionFlg] [smallint] NOT NULL,
	[SCACFlg] [smallint] NOT NULL,
	[ScheduledDateFlg] [smallint] NOT NULL,
	[SDQMarkForFlg] [smallint] NOT NULL,
	[SendZeroInvc] [smallint] NOT NULL,
	[SepDestOrd] [smallint] NOT NULL,
	[ShipDateFlg] [smallint] NOT NULL,
	[ShipmentLabel] [char](30) NOT NULL,
	[ShipMthPayFlg] [smallint] NOT NULL,
	[ShipNBDateFlg] [smallint] NOT NULL,
	[ShipNLDateFlg] [smallint] NOT NULL,
	[ShipToRefNbrFlg] [smallint] NOT NULL,
	[ShipViaFlg] [smallint] NOT NULL,
	[ShipWeekOfFlg] [smallint] NOT NULL,
	[SingleContainer] [smallint] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsSub] [char](31) NOT NULL,
	[SOTypeID] [char](4) NOT NULL,
	[SOUser10Flg] [smallint] NOT NULL,
	[SOUser1Flg] [smallint] NOT NULL,
	[SOUser2Flg] [smallint] NOT NULL,
	[SOUser3Flg] [smallint] NOT NULL,
	[SOUser4Flg] [smallint] NOT NULL,
	[SOUser5Flg] [smallint] NOT NULL,
	[SOUser6Flg] [smallint] NOT NULL,
	[SOUser7Flg] [smallint] NOT NULL,
	[SOUser8Flg] [smallint] NOT NULL,
	[SOUser9Flg] [smallint] NOT NULL,
	[SplitPartialLineDisc] [smallint] NOT NULL,
	[SubNbrFlg] [smallint] NOT NULL,
	[SubstOK] [smallint] NOT NULL,
	[TerritoryID] [char](10) NOT NULL,
	[TrackingNbrFlg] [smallint] NOT NULL,
	[UseEDIPrice] [smallint] NOT NULL,
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
	[UserNoteID1] [int] NOT NULL,
	[UserNoteID2] [int] NOT NULL,
	[UserNoteID3] [int] NOT NULL,
	[VolumeFlg] [smallint] NOT NULL,
	[WebSite] [char](40) NOT NULL,
	[WeightFlg] [smallint] NOT NULL,
	[WholeOrdEDIDiscCode] [char](5) NOT NULL,
	[WidthFlg] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [AgreeNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ApptNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ArrivalDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [BatchNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [BidNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [BOLFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [BOLNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [BOLRptFormat]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [BuyerReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [CertID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [CheckShipToID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ContractNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [ContTrackLevel]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [CreditMgrID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [CreditRule]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [CrossDockFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [CustCommClassID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [CustItemReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [DeliveryDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [DeptFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [DfltBuyerID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [DivFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser10Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser1Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser2Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser3Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser4Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser5Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser6Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser7Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser8Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EDSOUser9Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [EquipNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [FOBFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [FOBID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [FOBLocQualFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [FOBTranTypeFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [FrtAllowCd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [FrtDiscCd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [GeoCode]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [GLClassID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [GracePer]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [GSA]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [HeightFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [ImpConvMeth]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [InternalNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [IntVendorNbr]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [IntVendorNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [InvcNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [LabelReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [LenFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [LineItemEDIDiscCode]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [MajorAccount]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ManNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [MinOrder]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [MinWt]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [MiscAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [MiscSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [MultiDestMeth]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [NbrCartonsFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [OrigSourceID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [OutBndTemplate]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [PlanDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [POReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [PROFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [PromoNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [PSNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [PTNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [QuoteNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [RegionID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [RequestDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SalespersonFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SalesRegionFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SCACFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ScheduledDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SDQMarkForFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SendZeroInvc]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SepDestOrd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [ShipmentLabel]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipMthPayFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipNBDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipNLDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipToRefNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipViaFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [ShipWeekOfFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SingleContainer]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser10Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser1Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser2Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser3Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser4Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser5Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser6Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser7Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser8Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SOUser9Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SplitPartialLineDisc]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SubNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [SubstOK]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [TerritoryID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [TrackingNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [UseEDIPrice]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [UserNoteID1]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [UserNoteID2]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [UserNoteID3]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [VolumeFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [WebSite]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [WeightFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT (' ') FOR [WholeOrdEDIDiscCode]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  DEFAULT ((0)) FOR [WidthFlg]
GO
