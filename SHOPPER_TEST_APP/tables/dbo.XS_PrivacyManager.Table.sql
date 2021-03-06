USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[XS_PrivacyManager]    Script Date: 12/21/2015 16:06:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[XS_PrivacyManager](
	[Acct] [char](10) NOT NULL,
	[AcctClassId] [char](10) NOT NULL,
	[APDiscDate] [char](20) NOT NULL,
	[APDocDate] [char](20) NOT NULL,
	[APDocRefNbr] [char](15) NOT NULL,
	[APDueDate] [char](20) NOT NULL,
	[ARDiscDate] [char](20) NOT NULL,
	[ARDocDate] [char](20) NOT NULL,
	[ARDocRefNbr] [char](15) NOT NULL,
	[ARDueDate] [char](20) NOT NULL,
	[BankAcct] [char](10) NOT NULL,
	[BankSub] [char](24) NOT NULL,
	[BuyerID] [char](10) NOT NULL,
	[CashEntryType] [char](2) NOT NULL,
	[CountryId] [char](3) NOT NULL,
	[CreditMgrId] [char](10) NOT NULL,
	[CRTD_Date] [smalldatetime] NOT NULL,
	[CRTD_DateMask] [char](20) NOT NULL,
	[CRTD_Prog] [char](8) NOT NULL,
	[CRTD_Time] [char](6) NOT NULL,
	[CRTD_User] [char](10) NOT NULL,
	[CRTD_UserMask] [char](10) NOT NULL,
	[CuryId] [char](10) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[CustomDate01] [char](20) NOT NULL,
	[CustomDate02] [char](20) NOT NULL,
	[CustomDate03] [char](20) NOT NULL,
	[CustomDate04] [char](20) NOT NULL,
	[CustomDate05] [char](20) NOT NULL,
	[CustomDate06] [char](20) NOT NULL,
	[CustomDate07] [char](20) NOT NULL,
	[CustomDate08] [char](20) NOT NULL,
	[CustomerClassID] [char](6) NOT NULL,
	[CustomString01] [char](30) NOT NULL,
	[CustomString02] [char](30) NOT NULL,
	[CustomString03] [char](30) NOT NULL,
	[CustomString04] [char](30) NOT NULL,
	[CustomString05] [char](10) NOT NULL,
	[CustomString06] [char](10) NOT NULL,
	[CustomString07] [char](10) NOT NULL,
	[CustomString08] [char](10) NOT NULL,
	[EmpId] [char](10) NOT NULL,
	[ExtRefNbr] [char](15) NOT NULL,
	[InventoryClassID] [char](6) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[KitId] [char](30) NOT NULL,
	[LbrClassId] [char](10) NOT NULL,
	[LedgerId] [char](10) NOT NULL,
	[LUPD_Date] [smalldatetime] NOT NULL,
	[LUPD_DateMask] [char](20) NOT NULL,
	[LUPD_Prog] [char](8) NOT NULL,
	[LUPD_Time] [char](6) NOT NULL,
	[LUPD_User] [char](10) NOT NULL,
	[LUPD_UserMask] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[OrderNbr] [char](10) NOT NULL,
	[OrdFromId] [char](10) NOT NULL,
	[PerClosed] [char](20) NOT NULL,
	[PerEnt] [char](20) NOT NULL,
	[PerPost] [char](20) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProdLineId] [char](4) NOT NULL,
	[ProdMgrId] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
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
	[ScreenID] [char](7) NOT NULL,
	[ShipperId] [char](15) NOT NULL,
	[ShipToId] [char](10) NOT NULL,
	[ShipViaId] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[State] [char](3) NOT NULL,
	[SubAcct] [char](24) NOT NULL,
	[TaskID] [char](30) NOT NULL,
	[Territory] [char](10) NOT NULL,
	[UseAndOr] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[ValidationScreen] [smallint] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[VendorClassId] [char](10) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[WorkCenterId] [char](10) NOT NULL,
	[WrkLocId] [char](6) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [AcctClassId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [APDiscDate]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [APDocDate]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [APDocRefNbr]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [APDueDate]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ARDiscDate]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ARDocDate]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ARDocRefNbr]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ARDueDate]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [BankAcct]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [BankSub]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [BuyerID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CashEntryType]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CountryId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CreditMgrId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [CRTD_Date]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_DateMask]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_Prog]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_Time]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_User]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_UserMask]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CuryId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate01]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate02]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate03]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate04]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate05]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate06]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate07]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomDate08]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomerClassID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString01]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString02]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString03]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString04]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString05]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString06]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString07]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [CustomString08]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [EmpId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ExtRefNbr]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [InventoryClassID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [KitId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LbrClassId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LedgerId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [LUPD_Date]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_DateMask]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_Prog]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_Time]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_User]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_UserMask]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [OrderNbr]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [OrdFromId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ProdLineId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ProdMgrId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ScreenID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ShipperId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ShipToId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [ShipViaId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [SubAcct]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [Territory]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [UseAndOr]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [UserID]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT ((0)) FOR [ValidationScreen]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [VendId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [VendorClassId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [WorkCenterId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [WrkLocId]
GO
ALTER TABLE [dbo].[XS_PrivacyManager] ADD  DEFAULT (' ') FOR [Zip]
GO
