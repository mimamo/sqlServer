USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[EDSOHeader]    Script Date: 12/21/2015 13:43:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDSOHeader](
	[AgreeNbr] [char](30) NOT NULL,
	[ApptNbr] [char](30) NOT NULL,
	[ArrivalDate] [smalldatetime] NOT NULL,
	[BatchNbr] [char](30) NOT NULL,
	[BidNbr] [char](30) NOT NULL,
	[BOLNoteId] [int] NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CrossDock] [char](20) NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeliveryDate] [smalldatetime] NOT NULL,
	[EndCustPODate] [smalldatetime] NOT NULL,
	[FOBLocQual] [char](2) NOT NULL,
	[FOBTranType] [char](2) NOT NULL,
	[InternalNoteId] [int] NOT NULL,
	[InvcNoteId] [int] NOT NULL,
	[LabelSuffix] [char](3) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[ManNoteId] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[PRO] [char](20) NOT NULL,
	[PromoNbr] [char](30) NOT NULL,
	[PSNoteId] [int] NOT NULL,
	[PTNoteId] [int] NOT NULL,
	[QuoteNbr] [char](30) NOT NULL,
	[RegionId] [char](10) NOT NULL,
	[RequestedDate] [smalldatetime] NOT NULL,
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
	[SalesRegion] [char](30) NOT NULL,
	[ScheduledDate] [smalldatetime] NOT NULL,
	[ShipMthPay] [char](2) NOT NULL,
	[ShipNBDate] [smalldatetime] NOT NULL,
	[ShipNLDate] [smalldatetime] NOT NULL,
	[ShipWeekOf] [smalldatetime] NOT NULL,
	[SingleContainer] [smallint] NOT NULL,
	[SourceCode] [char](10) NOT NULL,
	[SubNbr] [char](30) NOT NULL,
	[TerritoryId] [char](10) NOT NULL,
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
	[UserNoteId1] [int] NOT NULL,
	[UserNoteId2] [int] NOT NULL,
	[UserNoteId3] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_AgreeNbr]  DEFAULT (' ') FOR [AgreeNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ApptNbr]  DEFAULT (' ') FOR [ApptNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ArrivalDate]  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_BatchNbr]  DEFAULT (' ') FOR [BatchNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_BidNbr]  DEFAULT (' ') FOR [BidNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_BOLNoteId]  DEFAULT ((0)) FOR [BOLNoteId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_CpnyId]  DEFAULT (' ') FOR [CpnyId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_CrossDock]  DEFAULT (' ') FOR [CrossDock]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_Crtd_Datetime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_DeliveryDate]  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_EndCustPODate]  DEFAULT ('01/01/1900') FOR [EndCustPODate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_FOBLocQual]  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_FOBTranType]  DEFAULT (' ') FOR [FOBTranType]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_InternalNoteId]  DEFAULT ((0)) FOR [InternalNoteId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_InvcNoteId]  DEFAULT ((0)) FOR [InvcNoteId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_LabelSuffix]  DEFAULT (' ') FOR [LabelSuffix]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_Lupd_Datetime]  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ManNoteId]  DEFAULT ((0)) FOR [ManNoteId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_PRO]  DEFAULT (' ') FOR [PRO]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_PromoNbr]  DEFAULT (' ') FOR [PromoNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_PSNoteId]  DEFAULT ((0)) FOR [PSNoteId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_PTNoteId]  DEFAULT ((0)) FOR [PTNoteId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_QuoteNbr]  DEFAULT (' ') FOR [QuoteNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_RegionId]  DEFAULT (' ') FOR [RegionId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_RequestedDate]  DEFAULT ('01/01/1900') FOR [RequestedDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_SalesRegion]  DEFAULT (' ') FOR [SalesRegion]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ScheduledDate]  DEFAULT ('01/01/1900') FOR [ScheduledDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ShipMthPay]  DEFAULT (' ') FOR [ShipMthPay]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ShipNBDate]  DEFAULT ('01/01/1900') FOR [ShipNBDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ShipNLDate]  DEFAULT ('01/01/1900') FOR [ShipNLDate]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_ShipWeekOf]  DEFAULT ('01/01/1900') FOR [ShipWeekOf]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_SingleContainer]  DEFAULT ((0)) FOR [SingleContainer]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_SourceCode]  DEFAULT (' ') FOR [SourceCode]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_SubNbr]  DEFAULT (' ') FOR [SubNbr]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_TerritoryId]  DEFAULT (' ') FOR [TerritoryId]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_UserNoteId1]  DEFAULT ((0)) FOR [UserNoteId1]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_UserNoteId2]  DEFAULT ((0)) FOR [UserNoteId2]
GO
ALTER TABLE [dbo].[EDSOHeader] ADD  CONSTRAINT [DF_EDSOHeader_UserNoteId3]  DEFAULT ((0)) FOR [UserNoteId3]
GO
