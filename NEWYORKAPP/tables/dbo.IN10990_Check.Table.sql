USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[IN10990_Check]    Script Date: 12/21/2015 16:00:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10990_Check](
	[BatNbr] [char](10) NOT NULL,
	[BMITotCost] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LayerType] [char](1) NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Qty] [float] NOT NULL,
	[Rate] [float] NOT NULL,
	[RcptDate] [smalldatetime] NOT NULL,
	[RcptNbr] [char](15) NOT NULL,
	[RefNbr] [char](15) NOT NULL,
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
	[TotCost] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[TranType] [char](2) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[ValMthd] [char](1) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [BMITotCost]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [LayerType]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [Rate]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ('01/01/1900') FOR [RcptDate]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [TranDesc]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [ValMthd]
GO
ALTER TABLE [dbo].[IN10990_Check] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
