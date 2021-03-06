USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[XS_ReportPrivacy]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[XS_ReportPrivacy](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [char](6) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FieldName00] [char](20) NOT NULL,
	[FieldName01] [char](20) NOT NULL,
	[FieldName02] [char](20) NOT NULL,
	[FieldName03] [char](20) NOT NULL,
	[FieldName04] [char](20) NOT NULL,
	[FieldName05] [char](20) NOT NULL,
	[FieldName06] [char](20) NOT NULL,
	[FieldName07] [char](20) NOT NULL,
	[FieldName08] [char](20) NOT NULL,
	[FieldName09] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_Time] [char](6) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[ObjectName00] [char](20) NOT NULL,
	[ObjectName01] [char](20) NOT NULL,
	[ObjectName02] [char](20) NOT NULL,
	[ObjectName03] [char](20) NOT NULL,
	[ObjectName04] [char](20) NOT NULL,
	[ObjectName05] [char](20) NOT NULL,
	[ObjectName06] [char](20) NOT NULL,
	[ObjectName07] [char](20) NOT NULL,
	[ObjectName08] [char](20) NOT NULL,
	[ObjectName09] [char](20) NOT NULL,
	[PrivacyMaskIndex00] [char](2) NOT NULL,
	[PrivacyMaskIndex01] [char](2) NOT NULL,
	[PrivacyMaskIndex02] [char](2) NOT NULL,
	[PrivacyMaskIndex03] [char](2) NOT NULL,
	[PrivacyMaskIndex04] [char](2) NOT NULL,
	[PrivacyMaskIndex05] [char](2) NOT NULL,
	[PrivacyMaskIndex06] [char](2) NOT NULL,
	[PrivacyMaskIndex07] [char](2) NOT NULL,
	[PrivacyMaskIndex08] [char](2) NOT NULL,
	[PrivacyMaskIndex09] [char](2) NOT NULL,
	[ReportFormat] [char](30) NOT NULL,
	[ReportName] [char](40) NOT NULL,
	[ReportNbr] [char](5) NOT NULL,
	[RunBeforeApplic] [char](8) NOT NULL,
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
	[StdRunBeforeApplic] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ('1/1/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName00]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName01]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName02]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName03]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName04]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName05]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName06]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName07]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName08]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [FieldName09]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ('1/1/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [LUpd_Time]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName00]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName01]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName02]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName03]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName04]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName05]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName06]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName07]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName08]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ObjectName09]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex00]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex01]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex02]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex03]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex04]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex05]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex06]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex07]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex08]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [PrivacyMaskIndex09]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ReportFormat]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ReportName]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [ReportNbr]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [RunBeforeApplic]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ('1/1/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ('1/1/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [StdRunBeforeApplic]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ('1/1/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XS_ReportPrivacy] ADD  DEFAULT ('1/1/1900') FOR [User8]
GO
