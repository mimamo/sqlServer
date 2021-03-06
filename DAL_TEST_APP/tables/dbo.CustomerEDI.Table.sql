USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[CustomerEDI]    Script Date: 12/21/2015 13:56:13 ******/
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
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_AgreeNbrFlg]  DEFAULT ((0)) FOR [AgreeNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ApptNbrFlg]  DEFAULT ((0)) FOR [ApptNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ArrivalDateFlg]  DEFAULT ((0)) FOR [ArrivalDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_BatchNbrFlg]  DEFAULT ((0)) FOR [BatchNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_BidNbrFlg]  DEFAULT ((0)) FOR [BidNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_BOLFlg]  DEFAULT ((0)) FOR [BOLFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_BOLNoteID]  DEFAULT ((0)) FOR [BOLNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_BOLRptFormat]  DEFAULT (' ') FOR [BOLRptFormat]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_BuyerReqd]  DEFAULT ((0)) FOR [BuyerReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CertID]  DEFAULT (' ') FOR [CertID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CheckShipToID]  DEFAULT ((0)) FOR [CheckShipToID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_COGSAcct]  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_COGSSub]  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ContractNbrFlg]  DEFAULT ((0)) FOR [ContractNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ContTrackLevel]  DEFAULT (' ') FOR [ContTrackLevel]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CreditMgrID]  DEFAULT (' ') FOR [CreditMgrID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CreditRule]  DEFAULT (' ') FOR [CreditRule]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CrossDockFlg]  DEFAULT ((0)) FOR [CrossDockFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CustCommClassID]  DEFAULT (' ') FOR [CustCommClassID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_CustItemReqd]  DEFAULT ((0)) FOR [CustItemReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_DeliveryDateFlg]  DEFAULT ((0)) FOR [DeliveryDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_DeptFlg]  DEFAULT ((0)) FOR [DeptFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_DfltBuyerID]  DEFAULT (' ') FOR [DfltBuyerID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_DiscAcct]  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_DiscSub]  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_DivFlg]  DEFAULT ((0)) FOR [DivFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser10Flg]  DEFAULT ((0)) FOR [EDSOUser10Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser1Flg]  DEFAULT ((0)) FOR [EDSOUser1Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser2Flg]  DEFAULT ((0)) FOR [EDSOUser2Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser3Flg]  DEFAULT ((0)) FOR [EDSOUser3Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser4Flg]  DEFAULT ((0)) FOR [EDSOUser4Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser5Flg]  DEFAULT ((0)) FOR [EDSOUser5Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser6Flg]  DEFAULT ((0)) FOR [EDSOUser6Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser7Flg]  DEFAULT ((0)) FOR [EDSOUser7Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser8Flg]  DEFAULT ((0)) FOR [EDSOUser8Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EDSOUser9Flg]  DEFAULT ((0)) FOR [EDSOUser9Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_EquipNbrFlg]  DEFAULT ((0)) FOR [EquipNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FOBFlg]  DEFAULT ((0)) FOR [FOBFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FOBID]  DEFAULT (' ') FOR [FOBID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FOBLocQualFlg]  DEFAULT ((0)) FOR [FOBLocQualFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FOBTranTypeFlg]  DEFAULT ((0)) FOR [FOBTranTypeFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FrtAcct]  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FrtAllowCd]  DEFAULT (' ') FOR [FrtAllowCd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FrtDiscCd]  DEFAULT (' ') FOR [FrtDiscCd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_FrtSub]  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_GeoCode]  DEFAULT (' ') FOR [GeoCode]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_GLClassID]  DEFAULT (' ') FOR [GLClassID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_GracePer]  DEFAULT ((0)) FOR [GracePer]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_GSA]  DEFAULT ((0)) FOR [GSA]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_HeightFlg]  DEFAULT ((0)) FOR [HeightFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ImpConvMeth]  DEFAULT (' ') FOR [ImpConvMeth]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_InternalNoteID]  DEFAULT ((0)) FOR [InternalNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_IntVendorNbr]  DEFAULT (' ') FOR [IntVendorNbr]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_IntVendorNbrFlg]  DEFAULT ((0)) FOR [IntVendorNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_InvcNoteID]  DEFAULT ((0)) FOR [InvcNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_LabelReqd]  DEFAULT ((0)) FOR [LabelReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_LenFlg]  DEFAULT ((0)) FOR [LenFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_LineItemEDIDiscCode]  DEFAULT (' ') FOR [LineItemEDIDiscCode]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_MajorAccount]  DEFAULT (' ') FOR [MajorAccount]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ManNoteID]  DEFAULT ((0)) FOR [ManNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_MinOrder]  DEFAULT ((0)) FOR [MinOrder]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_MinWt]  DEFAULT ((0)) FOR [MinWt]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_MiscAcct]  DEFAULT (' ') FOR [MiscAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_MiscSub]  DEFAULT (' ') FOR [MiscSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_MultiDestMeth]  DEFAULT (' ') FOR [MultiDestMeth]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_NbrCartonsFlg]  DEFAULT ((0)) FOR [NbrCartonsFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_OrigSourceID]  DEFAULT (' ') FOR [OrigSourceID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_OutBndTemplate]  DEFAULT (' ') FOR [OutBndTemplate]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_PlanDateFlg]  DEFAULT ((0)) FOR [PlanDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_POReqd]  DEFAULT ((0)) FOR [POReqd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_PROFlg]  DEFAULT ((0)) FOR [PROFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_PromoNbrFlg]  DEFAULT ((0)) FOR [PromoNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_PSNoteID]  DEFAULT ((0)) FOR [PSNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_PTNoteID]  DEFAULT ((0)) FOR [PTNoteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_QuoteNbrFlg]  DEFAULT ((0)) FOR [QuoteNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_RegionID]  DEFAULT (' ') FOR [RegionID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_RequestDateFlg]  DEFAULT ((0)) FOR [RequestDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SalespersonFlg]  DEFAULT ((0)) FOR [SalespersonFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SalesRegionFlg]  DEFAULT ((0)) FOR [SalesRegionFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SCACFlg]  DEFAULT ((0)) FOR [SCACFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ScheduledDateFlg]  DEFAULT ((0)) FOR [ScheduledDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SDQMarkForFlg]  DEFAULT ((0)) FOR [SDQMarkForFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SendZeroInvc]  DEFAULT ((0)) FOR [SendZeroInvc]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SepDestOrd]  DEFAULT ((0)) FOR [SepDestOrd]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipDateFlg]  DEFAULT ((0)) FOR [ShipDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipmentLabel]  DEFAULT (' ') FOR [ShipmentLabel]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipMthPayFlg]  DEFAULT ((0)) FOR [ShipMthPayFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipNBDateFlg]  DEFAULT ((0)) FOR [ShipNBDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipNLDateFlg]  DEFAULT ((0)) FOR [ShipNLDateFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipToRefNbrFlg]  DEFAULT ((0)) FOR [ShipToRefNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipViaFlg]  DEFAULT ((0)) FOR [ShipViaFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_ShipWeekOfFlg]  DEFAULT ((0)) FOR [ShipWeekOfFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SingleContainer]  DEFAULT ((0)) FOR [SingleContainer]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SlsAcct]  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SlsSub]  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOTypeID]  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser10Flg]  DEFAULT ((0)) FOR [SOUser10Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser1Flg]  DEFAULT ((0)) FOR [SOUser1Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser2Flg]  DEFAULT ((0)) FOR [SOUser2Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser3Flg]  DEFAULT ((0)) FOR [SOUser3Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser4Flg]  DEFAULT ((0)) FOR [SOUser4Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser5Flg]  DEFAULT ((0)) FOR [SOUser5Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser6Flg]  DEFAULT ((0)) FOR [SOUser6Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser7Flg]  DEFAULT ((0)) FOR [SOUser7Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser8Flg]  DEFAULT ((0)) FOR [SOUser8Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SOUser9Flg]  DEFAULT ((0)) FOR [SOUser9Flg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SplitPartialLineDisc]  DEFAULT ((0)) FOR [SplitPartialLineDisc]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SubNbrFlg]  DEFAULT ((0)) FOR [SubNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_SubstOK]  DEFAULT ((0)) FOR [SubstOK]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_TerritoryID]  DEFAULT (' ') FOR [TerritoryID]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_TrackingNbrFlg]  DEFAULT ((0)) FOR [TrackingNbrFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_UseEDIPrice]  DEFAULT ((0)) FOR [UseEDIPrice]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_UserNoteID1]  DEFAULT ((0)) FOR [UserNoteID1]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_UserNoteID2]  DEFAULT ((0)) FOR [UserNoteID2]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_UserNoteID3]  DEFAULT ((0)) FOR [UserNoteID3]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_VolumeFlg]  DEFAULT ((0)) FOR [VolumeFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_WebSite]  DEFAULT (' ') FOR [WebSite]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_WeightFlg]  DEFAULT ((0)) FOR [WeightFlg]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_WholeOrdEDIDiscCode]  DEFAULT (' ') FOR [WholeOrdEDIDiscCode]
GO
ALTER TABLE [dbo].[CustomerEDI] ADD  CONSTRAINT [DF_CustomerEDI_WidthFlg]  DEFAULT ((0)) FOR [WidthFlg]
GO
