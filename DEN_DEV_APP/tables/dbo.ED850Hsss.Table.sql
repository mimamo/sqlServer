USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[ED850Hsss]    Script Date: 12/21/2015 14:05:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850Hsss](
	[AssocQualCode] [char](2) NOT NULL,
	[Code] [char](20) NOT NULL,
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
	[HssRate] [float] NOT NULL,
	[Indicator] [char](1) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Marks] [char](80) NOT NULL,
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
	[TotAmt] [float] NOT NULL,
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
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_AssocQualCode]  DEFAULT (' ') FOR [AssocQualCode]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Code]  DEFAULT (' ') FOR [Code]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_CuryTotAmt]  DEFAULT ((0)) FOR [CuryTotAmt]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Description]  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_HssRate]  DEFAULT ((0)) FOR [HssRate]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Indicator]  DEFAULT (' ') FOR [Indicator]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_Marks]  DEFAULT (' ') FOR [Marks]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_TotAmt]  DEFAULT ((0)) FOR [TotAmt]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850Hsss] ADD  CONSTRAINT [DF_ED850Hsss_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
