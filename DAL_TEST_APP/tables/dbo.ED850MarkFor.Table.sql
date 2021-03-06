USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[ED850MarkFor]    Script Date: 12/21/2015 13:56:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850MarkFor](
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MFAddr1] [char](55) NOT NULL,
	[MFAddr2] [char](55) NOT NULL,
	[MFAddr3] [char](55) NOT NULL,
	[MFAddr4] [char](55) NOT NULL,
	[MFCity] [char](30) NOT NULL,
	[MFCountryID] [char](3) NOT NULL,
	[MFName] [char](60) NOT NULL,
	[MFName2] [char](60) NOT NULL,
	[MFNbr] [char](80) NOT NULL,
	[MFState] [char](2) NOT NULL,
	[MFZip] [char](15) NOT NULL,
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
	[ShipToID] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFAddr1]  DEFAULT (' ') FOR [MFAddr1]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFAddr2]  DEFAULT (' ') FOR [MFAddr2]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFAddr3]  DEFAULT (' ') FOR [MFAddr3]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFAddr4]  DEFAULT (' ') FOR [MFAddr4]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFCity]  DEFAULT (' ') FOR [MFCity]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFCountryID]  DEFAULT (' ') FOR [MFCountryID]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFName]  DEFAULT (' ') FOR [MFName]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFName2]  DEFAULT (' ') FOR [MFName2]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFNbr]  DEFAULT (' ') FOR [MFNbr]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFState]  DEFAULT (' ') FOR [MFState]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_MFZip]  DEFAULT (' ') FOR [MFZip]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_ShipToID]  DEFAULT (' ') FOR [ShipToID]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850MarkFor] ADD  CONSTRAINT [DF_ED850MarkFor_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
