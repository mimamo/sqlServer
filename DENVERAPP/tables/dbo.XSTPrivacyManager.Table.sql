USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[XSTPrivacyManager]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[XSTPrivacyManager](
	[Acct] [varchar](10) NOT NULL,
	[AcctClassId] [varchar](10) NOT NULL,
	[AdvCriteriaNoteId] [int] NOT NULL,
	[APDiscDate] [varchar](20) NOT NULL,
	[APDocDate] [varchar](20) NOT NULL,
	[APDocRefNbr] [varchar](15) NOT NULL,
	[APDueDate] [varchar](20) NOT NULL,
	[ARDiscDate] [varchar](20) NOT NULL,
	[ARDocDate] [varchar](20) NOT NULL,
	[ARDocRefNbr] [varchar](15) NOT NULL,
	[ARDueDate] [varchar](20) NOT NULL,
	[BankAcct] [varchar](10) NOT NULL,
	[BankSub] [varchar](24) NOT NULL,
	[BuyerID] [varchar](10) NOT NULL,
	[CashEntryType] [varchar](2) NOT NULL,
	[CountryId] [varchar](3) NOT NULL,
	[CpnyID] [varchar](10) NOT NULL,
	[CpnyIdLoggedIn] [smallint] NOT NULL,
	[CreditMgrId] [varchar](10) NOT NULL,
	[CRTD_Date] [smalldatetime] NOT NULL,
	[CRTD_DateMask] [varchar](20) NOT NULL,
	[CRTD_Prog] [varchar](8) NOT NULL,
	[CRTD_Time] [varchar](6) NOT NULL,
	[CRTD_User] [varchar](10) NOT NULL,
	[CRTD_UserMask] [varchar](10) NOT NULL,
	[CuryId] [varchar](10) NOT NULL,
	[CustId] [varchar](15) NOT NULL,
	[CustomDate01] [varchar](20) NOT NULL,
	[CustomDate02] [varchar](20) NOT NULL,
	[CustomDate03] [varchar](20) NOT NULL,
	[CustomDate04] [varchar](20) NOT NULL,
	[CustomDate05] [varchar](20) NOT NULL,
	[CustomDate06] [varchar](20) NOT NULL,
	[CustomDate07] [varchar](20) NOT NULL,
	[CustomDate08] [varchar](20) NOT NULL,
	[CustomerClassID] [varchar](6) NOT NULL,
	[CustomFloat01] [float] NOT NULL,
	[CustomFloat02] [float] NOT NULL,
	[CustomFloat03] [float] NOT NULL,
	[CustomFloat04] [float] NOT NULL,
	[CustomFloat05] [float] NOT NULL,
	[CustomFloat06] [float] NOT NULL,
	[CustomFloat07] [float] NOT NULL,
	[CustomFloat08] [float] NOT NULL,
	[CustomString01] [varchar](30) NOT NULL,
	[CustomString02] [varchar](30) NOT NULL,
	[CustomString03] [varchar](30) NOT NULL,
	[CustomString04] [varchar](30) NOT NULL,
	[CustomString05] [varchar](10) NOT NULL,
	[CustomString06] [varchar](10) NOT NULL,
	[CustomString07] [varchar](10) NOT NULL,
	[CustomString08] [varchar](10) NOT NULL,
	[Department] [varchar](10) NOT NULL,
	[EmpId] [varchar](10) NOT NULL,
	[ExtRefNbr] [varchar](15) NOT NULL,
	[InventoryClassID] [varchar](6) NOT NULL,
	[InvtID] [varchar](30) NOT NULL,
	[KitId] [varchar](30) NOT NULL,
	[LbrClassId] [varchar](10) NOT NULL,
	[LedgerId] [varchar](10) NOT NULL,
	[LUPD_Date] [smalldatetime] NOT NULL,
	[LUPD_DateMask] [varchar](20) NOT NULL,
	[LUPD_Prog] [varchar](8) NOT NULL,
	[LUPD_Time] [varchar](6) NOT NULL,
	[LUPD_User] [varchar](10) NOT NULL,
	[LUPD_UserMask] [varchar](10) NOT NULL,
	[Manager1] [varchar](10) NOT NULL,
	[Manager2] [varchar](10) NOT NULL,
	[MaterialType] [varchar](10) NOT NULL,
	[OrderNbr] [varchar](10) NOT NULL,
	[OrdFromId] [varchar](10) NOT NULL,
	[PayGrpId] [varchar](6) NOT NULL,
	[PerClosed] [varchar](20) NOT NULL,
	[PerEnt] [varchar](20) NOT NULL,
	[PerPost] [varchar](20) NOT NULL,
	[PersonId] [varchar](10) NOT NULL,
	[PersonStatus] [varchar](1) NOT NULL,
	[PersonType] [varchar](10) NOT NULL,
	[PONbr] [varchar](10) NOT NULL,
	[ProdLineId] [varchar](4) NOT NULL,
	[ProdMgrId] [varchar](10) NOT NULL,
	[ProjectID] [varchar](16) NOT NULL,
	[S4Future01] [varchar](30) NOT NULL,
	[S4Future02] [varchar](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [varchar](10) NOT NULL,
	[S4Future12] [varchar](10) NOT NULL,
	[ScreenID] [varchar](7) NOT NULL,
	[ShipperId] [varchar](15) NOT NULL,
	[ShipToId] [varchar](10) NOT NULL,
	[ShipViaId] [varchar](15) NOT NULL,
	[SupervisorId] [varchar](10) NOT NULL,
	[SiteID] [varchar](10) NOT NULL,
	[SlsperID] [varchar](10) NOT NULL,
	[State] [varchar](3) NOT NULL,
	[SubAcct] [varchar](24) NOT NULL,
	[TaskID] [varchar](30) NOT NULL,
	[Territory] [varchar](10) NOT NULL,
	[UseAndOr] [varchar](1) NOT NULL,
	[User1] [varchar](30) NOT NULL,
	[User2] [varchar](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [varchar](10) NOT NULL,
	[User6] [varchar](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UserID] [varchar](47) NOT NULL,
	[ValidationScreen] [smallint] NOT NULL,
	[VendId] [varchar](15) NOT NULL,
	[VendorClassId] [varchar](10) NOT NULL,
	[WebId] [varchar](30) NOT NULL,
	[WebStatus] [varchar](1) NOT NULL,
	[WhseLoc] [varchar](10) NOT NULL,
	[WorkCenterId] [varchar](10) NOT NULL,
	[WrkLocId] [varchar](6) NOT NULL,
	[Zip] [varchar](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [Acct]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [AcctClassId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [AdvCriteriaNoteId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [APDiscDate]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [APDocDate]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [APDocRefNbr]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [APDueDate]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ARDiscDate]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ARDocDate]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ARDocRefNbr]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ARDueDate]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [BankAcct]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [BankSub]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [BuyerID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CashEntryType]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CountryId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CpnyIdLoggedIn]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CreditMgrId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [CRTD_Date]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CRTD_DateMask]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_Prog]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_Time]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [CRTD_User]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CRTD_UserMask]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CuryId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate01]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate02]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate03]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate04]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate05]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate06]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate07]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomDate08]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomerClassID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat01]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat02]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat03]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat04]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat05]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat06]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat07]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [CustomFloat08]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString01]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString02]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString03]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString04]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString05]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString06]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString07]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [CustomString08]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [Department]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [EmpId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ExtRefNbr]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [InventoryClassID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [InvtID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [KitId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [LbrClassId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [LedgerId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [LUPD_Date]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [LUPD_DateMask]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_Prog]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_Time]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [LUPD_User]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [LUPD_UserMask]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [Manager1]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [Manager2]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [MaterialType]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [OrderNbr]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [OrdFromId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PayGrpId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PerClosed]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PerEnt]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PerPost]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PersonId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PersonStatus]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PersonType]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [PONbr]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ProdLineId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ProdMgrId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ProjectID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [ScreenID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ShipperId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ShipToId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [ShipViaId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [SupervisorId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [SiteID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [SlsperID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [State]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [SubAcct]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [TaskID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [Territory]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [UseAndOr]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('1/1/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT (' ') FOR [UserID]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ((0)) FOR [ValidationScreen]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [VendId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [VendorClassId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [WebId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [WebStatus]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [WorkCenterId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [WrkLocId]
GO
ALTER TABLE [dbo].[XSTPrivacyManager] ADD  DEFAULT ('%') FOR [Zip]
GO
