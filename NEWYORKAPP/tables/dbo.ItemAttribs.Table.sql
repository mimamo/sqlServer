USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[ItemAttribs]    Script Date: 12/21/2015 16:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemAttribs](
	[Attrib00] [char](10) NOT NULL,
	[Attrib01] [char](10) NOT NULL,
	[Attrib02] [char](10) NOT NULL,
	[Attrib03] [char](10) NOT NULL,
	[Attrib04] [char](10) NOT NULL,
	[Attrib05] [char](10) NOT NULL,
	[Attrib06] [char](10) NOT NULL,
	[Attrib07] [char](10) NOT NULL,
	[Attrib08] [char](10) NOT NULL,
	[Attrib09] [char](10) NOT NULL,
	[ClassID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib00]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib01]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib02]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib03]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib04]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib05]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib06]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib07]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib08]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Attrib09]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [ClassID]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ItemAttribs] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
