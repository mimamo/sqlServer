USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[IRItemUsage]    Script Date: 12/21/2015 13:56:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IRItemUsage](
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DemActAdjust] [float] NOT NULL,
	[DemActual] [float] NOT NULL,
	[DemNonRecur] [float] NOT NULL,
	[DemOverRide] [float] NOT NULL,
	[DemProjected] [float] NOT NULL,
	[DemRolledup] [float] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Period] [char](6) NOT NULL,
	[Reason] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Crtd_Datetime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_DemActAdjust]  DEFAULT ((0)) FOR [DemActAdjust]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_DemActual]  DEFAULT ((0)) FOR [DemActual]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_DemNonRecur]  DEFAULT ((0)) FOR [DemNonRecur]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_DemOverRide]  DEFAULT ((0)) FOR [DemOverRide]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_DemProjected]  DEFAULT ((0)) FOR [DemProjected]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_DemRolledup]  DEFAULT ((0)) FOR [DemRolledup]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Lupd_Datetime]  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Period]  DEFAULT (' ') FOR [Period]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_Reason]  DEFAULT (' ') FOR [Reason]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[IRItemUsage] ADD  CONSTRAINT [DF_IRItemUsage_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
