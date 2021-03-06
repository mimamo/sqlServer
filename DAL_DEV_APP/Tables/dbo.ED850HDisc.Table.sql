USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[ED850HDisc]    Script Date: 12/21/2015 13:35:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850HDisc](
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
	[HDiscRate] [float] NOT NULL,
	[Indicator] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_AllChgQuantity]  DEFAULT ((0)) FOR [AllChgQuantity]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_AssocCode]  DEFAULT (' ') FOR [AssocCode]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_AssocQualCode]  DEFAULT (' ') FOR [AssocQualCode]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_CuryTotAmt]  DEFAULT ((0)) FOR [CuryTotAmt]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Description]  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_HDiscRate]  DEFAULT ((0)) FOR [HDiscRate]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Indicator]  DEFAULT (' ') FOR [Indicator]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_MethHandCode]  DEFAULT (' ') FOR [MethHandCode]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Number]  DEFAULT (' ') FOR [Number]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Pct]  DEFAULT ((0)) FOR [Pct]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_PercentQual]  DEFAULT (' ') FOR [PercentQual]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_SpecChgCode]  DEFAULT (' ') FOR [SpecChgCode]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_TotAmt]  DEFAULT ((0)) FOR [TotAmt]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_UOM]  DEFAULT (' ') FOR [UOM]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850HDisc] ADD  CONSTRAINT [DF_ED850HDisc_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
