USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[CustomBld]    Script Date: 12/21/2015 16:12:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomBld](
	[BMICost] [float] NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIEffDate] [smalldatetime] NOT NULL,
	[BMIExtPriceInvoice] [float] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[BMIRtTp] [char](6) NOT NULL,
	[BMIUnitPrice] [float] NOT NULL,
	[Configured] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCost] [float] NOT NULL,
	[CuryExtPrice] [float] NOT NULL,
	[CuryExtPriceInvoice] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryUnitPrice] [float] NOT NULL,
	[ExtPrice] [float] NOT NULL,
	[FeatureNbr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LevelNbr] [smallint] NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OptInvtID] [char](30) NOT NULL,
	[OrderLineRef] [char](5) NOT NULL,
	[OrderNbr] [char](10) NOT NULL,
	[ParFtrNbr] [char](4) NOT NULL,
	[ParOptInvtID] [char](30) NOT NULL,
	[Qty] [float] NOT NULL,
	[QtyPer] [float] NOT NULL,
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
	[Source] [char](2) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[UnitDesc] [char](6) NOT NULL,
	[UnitPrice] [float] NOT NULL,
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
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [BMICost]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [BMIExtPriceInvoice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [BMIUnitPrice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [Configured]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [CuryCost]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [CuryExtPrice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [CuryExtPriceInvoice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [CuryUnitPrice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [ExtPrice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [FeatureNbr]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [LevelNbr]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [OptInvtID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [OrderLineRef]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [OrderNbr]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [ParFtrNbr]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [ParOptInvtID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [QtyPer]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [Source]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[CustomBld] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
