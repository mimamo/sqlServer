USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[Inspection]    Script Date: 12/21/2015 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Inspection](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[InspID] [char](2) NOT NULL,
	[InspText00] [char](255) NOT NULL,
	[InspText01] [char](255) NOT NULL,
	[InspText02] [char](255) NOT NULL,
	[InspText03] [char](255) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [InspID]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [InspText00]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [InspText01]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [InspText02]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [InspText03]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[Inspection] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
