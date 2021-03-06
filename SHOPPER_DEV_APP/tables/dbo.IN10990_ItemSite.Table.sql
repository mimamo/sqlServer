USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[IN10990_ItemSite]    Script Date: 12/21/2015 14:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10990_ItemSite](
	[AvgCost] [float] NOT NULL,
	[BMIAvgCost] [float] NOT NULL,
	[BMIDirStdCst] [float] NOT NULL,
	[BMIFOvhStdCst] [float] NOT NULL,
	[BMILastCost] [float] NOT NULL,
	[BMIStdCost] [float] NOT NULL,
	[BMITotCost] [float] NOT NULL,
	[BMIVOvhStdCst] [float] NOT NULL,
	[Changed] [bit] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DirStdCst] [float] NOT NULL,
	[FOvhStdCst] [float] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LastCost] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MstStamp] [binary](8) NOT NULL,
	[MaxOnHand] [float] NOT NULL,
	[QtyOnHand] [float] NOT NULL,
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
	[SiteID] [char](10) NOT NULL,
	[StdCost] [float] NOT NULL,
	[StdCostDate] [smalldatetime] NOT NULL,
	[TotCost] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VOvhStdCst] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [AvgCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMIAvgCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMIDirStdCst]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMIFOvhStdCst]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMILastCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMIStdCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMITotCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [BMIVOvhStdCst]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [DirStdCst]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [FOvhStdCst]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [LastCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [MaxOnHand]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [QtyOnHand]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [StdCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ('01/01/1900') FOR [StdCostDate]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[IN10990_ItemSite] ADD  DEFAULT ((0)) FOR [VOvhStdCst]
GO
