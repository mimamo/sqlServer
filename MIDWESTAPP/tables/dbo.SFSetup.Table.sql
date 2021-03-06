USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[SFSetup]    Script Date: 12/21/2015 15:54:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SFSetup](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeleteClosedOrders] [smallint] NOT NULL,
	[DfltCpnyID] [char](10) NOT NULL,
	[DfltCustClass] [char](6) NOT NULL,
	[DfltMiscChrgID] [char](10) NOT NULL,
	[DfltPriceClassID] [char](6) NOT NULL,
	[DfltSiteID] [char](10) NOT NULL,
	[DfltSOTypeID] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MultiCury] [smallint] NOT NULL,
	[MultUOM] [smallint] NOT NULL,
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
	[SetupID] [char](2) NOT NULL,
	[TransferMode] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [DeleteClosedOrders]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [DfltCpnyID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [DfltCustClass]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [DfltMiscChrgID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [DfltPriceClassID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [DfltSiteID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [DfltSOTypeID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [MultiCury]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [MultUOM]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [TransferMode]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SFSetup] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
