USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[AttribDef]    Script Date: 12/21/2015 14:26:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AttribDef](
	[ClassID] [char](6) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr00] [char](30) NOT NULL,
	[Descr01] [char](30) NOT NULL,
	[Descr02] [char](30) NOT NULL,
	[Descr03] [char](30) NOT NULL,
	[Descr04] [char](30) NOT NULL,
	[Descr05] [char](30) NOT NULL,
	[Descr06] [char](30) NOT NULL,
	[Descr07] [char](30) NOT NULL,
	[Descr08] [char](30) NOT NULL,
	[Descr09] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Mask00] [char](10) NOT NULL,
	[Mask01] [char](10) NOT NULL,
	[Mask02] [char](10) NOT NULL,
	[Mask03] [char](10) NOT NULL,
	[Mask04] [char](10) NOT NULL,
	[Mask05] [char](10) NOT NULL,
	[Mask06] [char](10) NOT NULL,
	[Mask07] [char](10) NOT NULL,
	[Mask08] [char](10) NOT NULL,
	[Mask09] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
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
	[UnitDesc00] [char](6) NOT NULL,
	[UnitDesc01] [char](6) NOT NULL,
	[UnitDesc02] [char](6) NOT NULL,
	[UnitDesc03] [char](6) NOT NULL,
	[UnitDesc04] [char](6) NOT NULL,
	[UnitDesc05] [char](6) NOT NULL,
	[UnitDesc06] [char](6) NOT NULL,
	[UnitDesc07] [char](6) NOT NULL,
	[UnitDesc08] [char](6) NOT NULL,
	[UnitDesc09] [char](6) NOT NULL,
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
	[ValidationType00] [char](1) NOT NULL,
	[ValidationType01] [char](1) NOT NULL,
	[ValidationType02] [char](1) NOT NULL,
	[ValidationType03] [char](1) NOT NULL,
	[ValidationType04] [char](1) NOT NULL,
	[ValidationType05] [char](1) NOT NULL,
	[ValidationType06] [char](1) NOT NULL,
	[ValidationType07] [char](1) NOT NULL,
	[ValidationType08] [char](1) NOT NULL,
	[ValidationType09] [char](1) NOT NULL,
	[ValidValues00] [char](60) NOT NULL,
	[ValidValues01] [char](60) NOT NULL,
	[ValidValues02] [char](60) NOT NULL,
	[ValidValues03] [char](60) NOT NULL,
	[ValidValues04] [char](60) NOT NULL,
	[ValidValues05] [char](60) NOT NULL,
	[ValidValues06] [char](60) NOT NULL,
	[ValidValues07] [char](60) NOT NULL,
	[ValidValues08] [char](60) NOT NULL,
	[ValidValues09] [char](60) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ClassID]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr00]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr01]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr02]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr03]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr04]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr05]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr06]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr07]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr08]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Descr09]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask00]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask01]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask02]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask03]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask04]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask05]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask06]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask07]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask08]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [Mask09]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc00]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc01]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc02]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc03]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc04]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc05]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc06]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc07]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc08]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [UnitDesc09]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType00]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType01]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType02]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType03]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType04]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType05]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType06]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType07]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType08]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidationType09]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues00]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues01]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues02]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues03]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues04]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues05]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues06]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues07]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues08]
GO
ALTER TABLE [dbo].[AttribDef] ADD  DEFAULT (' ') FOR [ValidValues09]
GO
