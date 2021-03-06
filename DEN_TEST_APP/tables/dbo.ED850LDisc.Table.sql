USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[ED850LDisc]    Script Date: 12/21/2015 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850LDisc](
	[AllChgQuantity] [int] NOT NULL,
	[AssocCode] [char](15) NOT NULL,
	[AssocQualCode] [char](2) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTotAmt] [float] NOT NULL,
	[Description] [char](80) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[Indicator] [char](1) NOT NULL,
	[LDiscRate] [float] NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MethHandCode] [char](5) NOT NULL,
	[Number] [char](20) NOT NULL,
	[Pct] [float] NOT NULL,
	[PercentQual] [char](1) NOT NULL,
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
	[SpecChgCode] [char](5) NOT NULL,
	[TotAmt] [float] NOT NULL,
	[UOM] [char](6) NOT NULL,
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
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_AllChgQuantity]  DEFAULT ((0)) FOR [AllChgQuantity]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_AssocCode]  DEFAULT (' ') FOR [AssocCode]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_AssocQualCode]  DEFAULT (' ') FOR [AssocQualCode]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_CuryTotAmt]  DEFAULT ((0)) FOR [CuryTotAmt]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Description]  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Indicator]  DEFAULT (' ') FOR [Indicator]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_LDiscRate]  DEFAULT ((0)) FOR [LDiscRate]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_MethHandCode]  DEFAULT (' ') FOR [MethHandCode]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Number]  DEFAULT (' ') FOR [Number]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Pct]  DEFAULT ((0)) FOR [Pct]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_PercentQual]  DEFAULT (' ') FOR [PercentQual]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_SpecChgCode]  DEFAULT (' ') FOR [SpecChgCode]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_TotAmt]  DEFAULT ((0)) FOR [TotAmt]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_UOM]  DEFAULT (' ') FOR [UOM]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850LDisc] ADD  CONSTRAINT [DF_ED850LDisc_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
