USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[LocTable]    Script Date: 12/21/2015 16:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LocTable](
	[ABCCode] [char](2) NOT NULL,
	[AssemblyValid] [char](1) NOT NULL,
	[BinType] [char](2) NOT NULL,
	[CountStatus] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CycleID] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[InclQtyAvail] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[InvtIDValid] [char](1) NOT NULL,
	[LastBookQty] [float] NOT NULL,
	[LastCountDate] [smalldatetime] NOT NULL,
	[LastVarAmt] [float] NOT NULL,
	[LastVarPct] [float] NOT NULL,
	[LastVarQty] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MoveClass] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PickPriority] [smallint] NOT NULL,
	[PutAwayPriority] [smallint] NOT NULL,
	[ReceiptsValid] [char](1) NOT NULL,
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
	[SalesValid] [char](1) NOT NULL,
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
	[WOIssueValid] [char](1) NOT NULL,
	[WOProdValid] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [ABCCode]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('Y') FOR [AssemblyValid]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('N') FOR [BinType]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('A') FOR [CountStatus]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [CycleID]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((1)) FOR [InclQtyAvail]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('') FOR [InvtID]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('N') FOR [InvtIDValid]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [LastBookQty]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('01/01/1900') FOR [LastCountDate]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [LastVarAmt]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [LastVarPct]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [LastVarQty]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [MoveClass]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [PickPriority]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [PutAwayPriority]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('Y') FOR [ReceiptsValid]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('Y') FOR [SalesValid]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [WOIssueValid]
GO
ALTER TABLE [dbo].[LocTable] ADD  DEFAULT (' ') FOR [WOProdValid]
GO
