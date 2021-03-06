USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[CSDetail]    Script Date: 12/21/2015 15:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSDetail](
	[CalcExpl] [char](255) NOT NULL,
	[CommPct] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryLineCommAmt] [float] NOT NULL,
	[CuryLineCommTotal] [float] NOT NULL,
	[CuryLinePlusAmt] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[ExtCost] [float] NOT NULL,
	[ExtPrice] [float] NOT NULL,
	[GMPct] [float] NOT NULL,
	[InvcLineNbr] [smallint] NOT NULL,
	[InvcRecordID] [int] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineCommAmt] [float] NOT NULL,
	[LineCommRate] [float] NOT NULL,
	[LineCommTotal] [float] NOT NULL,
	[LinePlusAmt] [float] NOT NULL,
	[LinePlusMult] [float] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrderLineNbr] [smallint] NOT NULL,
	[Price] [float] NOT NULL,
	[Qty] [float] NOT NULL,
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
	[SplitPct] [float] NOT NULL,
	[StmntID] [char](10) NOT NULL,
	[TranRef] [char](5) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [CalcExpl]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [CommPct]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [CuryLineCommAmt]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [CuryLineCommTotal]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [CuryLinePlusAmt]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [ExtPrice]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [GMPct]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [InvcLineNbr]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [InvcRecordID]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [LineCommAmt]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [LineCommRate]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [LineCommTotal]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [LinePlusAmt]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [LinePlusMult]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [OrderLineNbr]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [SplitPct]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [StmntID]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [TranRef]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CSDetail] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
