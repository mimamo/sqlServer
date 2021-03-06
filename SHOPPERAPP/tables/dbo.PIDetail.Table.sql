USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PIDetail]    Script Date: 12/21/2015 16:12:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PIDetail](
	[BookQty] [float] NOT NULL,
	[CostCtr] [int] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateFreeze] [smalldatetime] NOT NULL,
	[ExtCostVariance] [float] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[ItemDesc] [char](60) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotOrSer] [char](1) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MsgNbr] [char](4) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Number] [int] NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PhysQty] [float] NOT NULL,
	[PIID] [char](10) NOT NULL,
	[PIType] [char](2) NOT NULL,
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
	[SpecificCostID] [char](25) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[Unit] [char](10) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[ValMthd] [char](1) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [BookQty]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [CostCtr]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [DateFreeze]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [ExtCostVariance]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [ItemDesc]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [LotOrSer]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [MsgNbr]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [Number]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [PhysQty]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [PIID]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [PIType]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [Unit]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [ValMthd]
GO
ALTER TABLE [dbo].[PIDetail] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
