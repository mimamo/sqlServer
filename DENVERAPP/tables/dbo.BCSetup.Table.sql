USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[BCSetup]    Script Date: 12/21/2015 15:42:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BCSetup](
	[AllowBackOrders] [smallint] NOT NULL,
	[AllowCreditMemos] [smallint] NOT NULL,
	[AllowDebitMemos] [smallint] NOT NULL,
	[AllowImport] [smallint] NOT NULL,
	[AllowReceipts] [smallint] NOT NULL,
	[BatchHandling] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DefaultFreight] [smallint] NOT NULL,
	[DefaultQty] [float] NOT NULL,
	[DefaultSite] [char](6) NOT NULL,
	[DefaultWhseLoc] [smallint] NOT NULL,
	[EnterUnitOfMeasure] [smallint] NOT NULL,
	[Errors] [smallint] NOT NULL,
	[Freight] [float] NOT NULL,
	[ImportMode] [smallint] NOT NULL,
	[LogInfo] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MoveFromSite] [char](6) NOT NULL,
	[MoveToSite] [char](6) NOT NULL,
	[MultiSite] [smallint] NOT NULL,
	[PODefaultSite] [smallint] NOT NULL,
	[PreventAdds] [smallint] NOT NULL,
	[RunAppl] [smallint] NOT NULL,
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
	[ScanEach] [smallint] NOT NULL,
	[SetupID] [char](1) NOT NULL,
	[SHAccumQtys] [smallint] NOT NULL,
	[SHAllowBackOrds] [smallint] NOT NULL,
	[SHAllowDebitMemos] [smallint] NOT NULL,
	[SHAllowOverShip] [smallint] NOT NULL,
	[SHAllowReturns] [smallint] NOT NULL,
	[SHDefaultSite] [smallint] NOT NULL,
	[SHPromptFreight] [smallint] NOT NULL,
	[SHPromptMisc] [smallint] NOT NULL,
	[SHPromptUofM] [smallint] NOT NULL,
	[SHScanEach] [smallint] NOT NULL,
	[SHSubs] [smallint] NOT NULL,
	[SHValidateItem] [smallint] NOT NULL,
	[UseDefaultQty] [smallint] NOT NULL,
	[UseDefaultSite] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UseReceiver] [smallint] NOT NULL,
	[UseShipper] [smallint] NOT NULL,
	[ValidateItems] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_AllowBackOrders]  DEFAULT ((0)) FOR [AllowBackOrders]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_AllowCreditMemos]  DEFAULT ((0)) FOR [AllowCreditMemos]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_AllowDebitMemos]  DEFAULT ((0)) FOR [AllowDebitMemos]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_AllowImport]  DEFAULT ((0)) FOR [AllowImport]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_AllowReceipts]  DEFAULT ((0)) FOR [AllowReceipts]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_BatchHandling]  DEFAULT ((0)) FOR [BatchHandling]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_DefaultFreight]  DEFAULT ((0)) FOR [DefaultFreight]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_DefaultQty]  DEFAULT ((0)) FOR [DefaultQty]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_DefaultSite]  DEFAULT (' ') FOR [DefaultSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_DefaultWhseLoc]  DEFAULT ((0)) FOR [DefaultWhseLoc]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_EnterUnitOfMeasure]  DEFAULT ((0)) FOR [EnterUnitOfMeasure]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_Errors]  DEFAULT ((0)) FOR [Errors]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_Freight]  DEFAULT ((0)) FOR [Freight]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_ImportMode]  DEFAULT ((0)) FOR [ImportMode]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_LogInfo]  DEFAULT ((0)) FOR [LogInfo]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_MoveFromSite]  DEFAULT (' ') FOR [MoveFromSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_MoveToSite]  DEFAULT (' ') FOR [MoveToSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_MultiSite]  DEFAULT ((0)) FOR [MultiSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_PODefaultSite]  DEFAULT ((0)) FOR [PODefaultSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_PreventAdds]  DEFAULT ((0)) FOR [PreventAdds]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_RunAppl]  DEFAULT ((0)) FOR [RunAppl]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_ScanEach]  DEFAULT ((0)) FOR [ScanEach]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SetupID]  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHAccumQtys]  DEFAULT ((0)) FOR [SHAccumQtys]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHAllowBackOrds]  DEFAULT ((0)) FOR [SHAllowBackOrds]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHAllowDebitMemos]  DEFAULT ((0)) FOR [SHAllowDebitMemos]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHAllowOverShip]  DEFAULT ((0)) FOR [SHAllowOverShip]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHAllowReturns]  DEFAULT ((0)) FOR [SHAllowReturns]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHDefaultSite]  DEFAULT ((0)) FOR [SHDefaultSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHPromptFreight]  DEFAULT ((0)) FOR [SHPromptFreight]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHPromptMisc]  DEFAULT ((0)) FOR [SHPromptMisc]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHPromptUofM]  DEFAULT ((0)) FOR [SHPromptUofM]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHScanEach]  DEFAULT ((0)) FOR [SHScanEach]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHSubs]  DEFAULT ((0)) FOR [SHSubs]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_SHValidateItem]  DEFAULT ((0)) FOR [SHValidateItem]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_UseDefaultQty]  DEFAULT ((0)) FOR [UseDefaultQty]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_UseDefaultSite]  DEFAULT ((0)) FOR [UseDefaultSite]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_UseReceiver]  DEFAULT ((0)) FOR [UseReceiver]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_UseShipper]  DEFAULT ((0)) FOR [UseShipper]
GO
ALTER TABLE [dbo].[BCSetup] ADD  CONSTRAINT [DF_BCSetup_ValidateItems]  DEFAULT ((0)) FOR [ValidateItems]
GO
