USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[POTranAlloc]    Script Date: 12/21/2015 14:10:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POTranAlloc](
	[AllocRef] [char](5) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[POLineRef] [char](5) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[POTranLineRef] [char](5) NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
	[RcptQty] [float] NOT NULL,
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
	[SOLineRef] [char](5) NOT NULL,
	[SOOrdNbr] [char](15) NOT NULL,
	[SOSchedRef] [char](5) NOT NULL,
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
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_AllocRef]  DEFAULT (' ') FOR [AllocRef]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_POLineRef]  DEFAULT (' ') FOR [POLineRef]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_POTranLineRef]  DEFAULT (' ') FOR [POTranLineRef]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_RcptNbr]  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_RcptQty]  DEFAULT ((0)) FOR [RcptQty]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_SOLineRef]  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_SOOrdNbr]  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_SOSchedRef]  DEFAULT (' ') FOR [SOSchedRef]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POTranAlloc] ADD  CONSTRAINT [DF_POTranAlloc_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
