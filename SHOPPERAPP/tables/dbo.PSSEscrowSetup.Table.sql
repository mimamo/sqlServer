USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSEscrowSetup]    Script Date: 12/21/2015 16:12:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSEscrowSetup](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EscrowCRAcct] [char](10) NOT NULL,
	[EscrowCRSub] [char](24) NOT NULL,
	[EscrowDRAcct] [char](10) NOT NULL,
	[EscrowDRSub] [char](24) NOT NULL,
	[LastAcctId] [char](10) NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LastRefNbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PeriodLocked] [char](6) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PostInDetail] [smallint] NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[UseGLPerPost] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [EscrowCRAcct]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [EscrowCRSub]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [EscrowDRAcct]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [EscrowDRSub]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [LastAcctId]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [LastBatNbr]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [PeriodLocked]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [PerNbr]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ((0)) FOR [PostInDetail]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [SetupId]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ((0)) FOR [UseGLPerPost]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSEscrowSetup] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
