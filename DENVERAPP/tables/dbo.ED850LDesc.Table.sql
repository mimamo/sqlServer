USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[ED850LDesc]    Script Date: 12/21/2015 15:42:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850LDesc](
	[AgencyQualCode] [char](3) NOT NULL,
	[CharacteristicCode] [char](3) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Description] [char](80) NOT NULL,
	[DescriptionCode] [char](15) NOT NULL,
	[DescriptionType] [char](3) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[LanguageCode] [char](3) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_AgencyQualCode]  DEFAULT (' ') FOR [AgencyQualCode]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_CharacteristicCode]  DEFAULT (' ') FOR [CharacteristicCode]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Description]  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_DescriptionCode]  DEFAULT (' ') FOR [DescriptionCode]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_DescriptionType]  DEFAULT (' ') FOR [DescriptionType]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_LanguageCode]  DEFAULT (' ') FOR [LanguageCode]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850LDesc] ADD  CONSTRAINT [DF_ED850LDesc_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
