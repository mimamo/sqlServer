USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[BM11600_Wrk]    Script Date: 12/21/2015 15:42:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BM11600_Wrk](
	[CmpnentSiteID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](47) NOT NULL,
	[CSequence] [char](40) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[ISequence] [int] NOT NULL,
	[KitID] [char](30) NOT NULL,
	[KitNbr] [int] NOT NULL,
	[KitStatus] [char](1) NOT NULL,
	[LevelNbr] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](47) NOT NULL,
	[Quantity] [float] NOT NULL,
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
	[Sequence] [char](5) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[StartKit] [char](30) NOT NULL,
	[Status] [char](1) NOT NULL,
	[SubKitStatus] [char](1) NOT NULL,
	[TotQuantity] [float] NOT NULL,
	[TotStdQty] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_CmpnentSiteID]  DEFAULT (' ') FOR [CmpnentSiteID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_CSequence]  DEFAULT (' ') FOR [CSequence]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_ISequence]  DEFAULT ((0)) FOR [ISequence]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_KitNbr]  DEFAULT ((0)) FOR [KitNbr]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_KitStatus]  DEFAULT (' ') FOR [KitStatus]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_LevelNbr]  DEFAULT ((0)) FOR [LevelNbr]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_Quantity]  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_Sequence]  DEFAULT (' ') FOR [Sequence]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_StartKit]  DEFAULT (' ') FOR [StartKit]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_SubKitStatus]  DEFAULT (' ') FOR [SubKitStatus]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_TotQuantity]  DEFAULT ((0)) FOR [TotQuantity]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_TotStdQty]  DEFAULT ((0)) FOR [TotStdQty]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  CONSTRAINT [DF_BM11600_Wrk_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
