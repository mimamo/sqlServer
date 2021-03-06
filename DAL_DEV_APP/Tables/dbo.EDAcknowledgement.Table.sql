USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[EDAcknowledgement]    Script Date: 12/21/2015 13:35:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDAcknowledgement](
	[AckDate] [smalldatetime] NOT NULL,
	[AcknowledgementID] [int] IDENTITY(1,1) NOT NULL,
	[AckStatus] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EntityID] [char](35) NOT NULL,
	[EntityType] [smallint] NOT NULL,
	[GSNbr] [int] NOT NULL,
	[GSRcvID] [char](15) NOT NULL,
	[ISANbr] [int] NOT NULL,
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
	[SolomonDate] [smalldatetime] NOT NULL,
	[STNbr] [int] NOT NULL,
	[TranslatorDate] [smalldatetime] NOT NULL,
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
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_AckDate]  DEFAULT ('01/01/1900') FOR [AckDate]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_AckStatus]  DEFAULT ((0)) FOR [AckStatus]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_EntityID]  DEFAULT (' ') FOR [EntityID]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_EntityType]  DEFAULT ((0)) FOR [EntityType]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_GSNbr]  DEFAULT ((0)) FOR [GSNbr]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_GSRcvID]  DEFAULT (' ') FOR [GSRcvID]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_ISANbr]  DEFAULT ((0)) FOR [ISANbr]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_SolomonDate]  DEFAULT ('01/01/1900') FOR [SolomonDate]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_STNbr]  DEFAULT ((0)) FOR [STNbr]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_TranslatorDate]  DEFAULT ('01/01/1900') FOR [TranslatorDate]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDAcknowledgement] ADD  CONSTRAINT [DF_EDAcknowledgement_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
