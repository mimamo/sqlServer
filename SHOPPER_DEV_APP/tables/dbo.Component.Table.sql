USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[Component]    Script Date: 12/21/2015 14:33:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Component](
	[BomUsage] [char](3) NOT NULL,
	[CmpnentID] [char](30) NOT NULL,
	[CmpnentQty] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Deviation] [char](30) NOT NULL,
	[EngrChgOrder] [char](20) NOT NULL,
	[ExplodeFlg] [char](1) NOT NULL,
	[KitID] [char](30) NOT NULL,
	[KitSiteID] [char](10) NOT NULL,
	[KitStatus] [char](1) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[RtgStep] [char](5) NOT NULL,
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
	[ScrapPct] [float] NOT NULL,
	[Sequence] [char](5) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[Status] [char](1) NOT NULL,
	[StdQty] [float] NOT NULL,
	[StockUsage] [char](1) NOT NULL,
	[StopDate] [smalldatetime] NOT NULL,
	[SubKitStatus] [char](1) NOT NULL,
	[SupersededBy] [char](30) NOT NULL,
	[Supersedes] [char](30) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UTEFlag] [char](10) NOT NULL,
	[WONbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Component0] PRIMARY KEY CLUSTERED 
(
	[KitID] ASC,
	[KitSiteID] ASC,
	[KitStatus] ASC,
	[LineNbr] ASC,
	[CmpnentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [BomUsage]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [CmpnentID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [CmpnentQty]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [Deviation]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [EngrChgOrder]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [ExplodeFlg]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [KitSiteID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [KitStatus]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [RtgStep]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [ScrapPct]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [Sequence]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [StdQty]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [StockUsage]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [StopDate]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [SubKitStatus]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [SupersededBy]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [Supersedes]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [UTEFlag]
GO
ALTER TABLE [dbo].[Component] ADD  DEFAULT (' ') FOR [WONbr]
GO
