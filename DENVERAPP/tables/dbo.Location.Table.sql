USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 12/21/2015 15:42:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Location](
	[CountStatus] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[QtyAlloc] [float] NOT NULL,
	[QtyAllocBM] [float] NOT NULL,
	[QtyAllocIN] [float] NOT NULL,
	[QtyAllocOther] [float] NOT NULL,
	[QtyAllocPORet] [float] NOT NULL,
	[QtyAllocSD] [float] NOT NULL,
	[QtyAllocSO] [float] NOT NULL,
	[QtyAvail] [float] NOT NULL,
	[QtyOnHand] [float] NOT NULL,
	[QtyShipNotInv] [float] NOT NULL,
	[QtyWORlsedDemand] [float] NOT NULL,
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
	[Selected] [smallint] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_CountStatus]  DEFAULT ('A') FOR [CountStatus]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAlloc]  DEFAULT ((0)) FOR [QtyAlloc]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAllocBM]  DEFAULT ((0)) FOR [QtyAllocBM]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAllocIN]  DEFAULT ((0)) FOR [QtyAllocIN]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAllocOther]  DEFAULT ((0)) FOR [QtyAllocOther]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAllocPORet]  DEFAULT ((0)) FOR [QtyAllocPORet]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAllocSD]  DEFAULT ((0)) FOR [QtyAllocSD]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAllocSO]  DEFAULT ((0)) FOR [QtyAllocSO]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyAvail]  DEFAULT ((0)) FOR [QtyAvail]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyOnHand]  DEFAULT ((0)) FOR [QtyOnHand]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyShipNotInv]  DEFAULT ((0)) FOR [QtyShipNotInv]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_QtyWORlsedDemand]  DEFAULT ((0)) FOR [QtyWORlsedDemand]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
