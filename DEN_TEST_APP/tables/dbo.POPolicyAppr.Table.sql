USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[POPolicyAppr]    Script Date: 12/21/2015 14:10:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POPolicyAppr](
	[Authority] [char](2) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[PolicyID] [char](10) NOT NULL,
	[RequestType] [char](2) NOT NULL,
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
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_Authority]  DEFAULT (' ') FOR [Authority]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_DocType]  DEFAULT (' ') FOR [DocType]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_EffDate]  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_MaterialType]  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_PolicyID]  DEFAULT (' ') FOR [PolicyID]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_RequestType]  DEFAULT (' ') FOR [RequestType]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POPolicyAppr] ADD  CONSTRAINT [DF_POPolicyAppr_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
