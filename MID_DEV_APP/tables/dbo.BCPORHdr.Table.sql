USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[BCPORHdr]    Script Date: 12/21/2015 14:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BCPORHdr](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Freight] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PONumber] [char](10) NOT NULL,
	[RefNbr] [char](6) NOT NULL,
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
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [Freight]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [PONumber]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BCPORHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
