USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PIHeader]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PIHeader](
	[ControlQty] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateFreeze] [smalldatetime] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[FNumber] [int] NOT NULL,
	[LineCntr] [int] NOT NULL,
	[LNumber] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Numbered] [smallint] NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PhysAdjVarAcct] [char](10) NOT NULL,
	[PhysAdjVarSub] [char](24) NOT NULL,
	[PIID] [char](10) NOT NULL,
	[PITagType] [char](1) NOT NULL,
	[PIType] [char](1) NOT NULL,
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
	[Status] [char](1) NOT NULL,
	[TNumber] [int] NOT NULL,
	[TotBookAmt] [float] NOT NULL,
	[TotBookQty] [float] NOT NULL,
	[TotVarAmt] [float] NOT NULL,
	[TotVarQty] [float] NOT NULL,
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
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [ControlQty]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ('01/01/1900') FOR [DateFreeze]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [FNumber]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [LNumber]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [Numbered]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [PhysAdjVarAcct]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [PhysAdjVarSub]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [PIID]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [PITagType]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [PIType]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [TNumber]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [TotBookAmt]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [TotBookQty]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [TotVarAmt]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [TotVarQty]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PIHeader] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
