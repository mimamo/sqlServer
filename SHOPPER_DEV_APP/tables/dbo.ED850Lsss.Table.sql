USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[ED850Lsss]    Script Date: 12/21/2015 14:33:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850Lsss](
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
	[Indicator] [char](1) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LsssRate] [float] NOT NULL,
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
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [AssocQualCode]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Code]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [CuryTotAmt]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Indicator]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [LsssRate]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [Marks]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [TotAmt]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850Lsss] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
