USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[BM11600_Wrk]    Script Date: 12/21/2015 16:12:19 ******/
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
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [CmpnentSiteID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [CSequence]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [ISequence]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [KitNbr]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [KitStatus]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [LevelNbr]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [Sequence]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [StartKit]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [SubKitStatus]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [TotQuantity]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [TotStdQty]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BM11600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
