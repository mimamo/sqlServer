USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[EDSetup]    Script Date: 12/21/2015 16:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDSetup](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DecPlPct] [smallint] NOT NULL,
	[DecPlPrcCst] [smallint] NOT NULL,
	[DecPlqty] [smallint] NOT NULL,
	[DeleteDta] [smallint] NOT NULL,
	[EmailAddr] [char](255) NOT NULL,
	[EmailRptLevel] [smallint] NOT NULL,
	[EngineIn] [char](255) NOT NULL,
	[EngineOut] [char](255) NOT NULL,
	[InDataDir] [char](255) NOT NULL,
	[InTranslatorVerify] [smallint] NOT NULL,
	[InvcCustomObj] [char](255) NOT NULL,
	[InvcRecheck] [smallint] NOT NULL,
	[InvcRunUserEXE] [smallint] NOT NULL,
	[InvcTranControl] [char](255) NOT NULL,
	[InvcUserEXE] [char](255) NOT NULL,
	[InvcUseTI] [smallint] NOT NULL,
	[LastEDIInvID] [char](10) NOT NULL,
	[LastEDIPOID] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[ObjectConnectStr] [char](255) NOT NULL,
	[OutDataDir] [char](255) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[POCustomObj] [char](255) NOT NULL,
	[PORecheck] [smallint] NOT NULL,
	[PORunUserEXE] [smallint] NOT NULL,
	[POTranControl] [char](255) NOT NULL,
	[POUserEXE] [char](255) NOT NULL,
	[POUseTI] [smallint] NOT NULL,
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
	[SendEmail] [smallint] NOT NULL,
	[SetupID] [char](2) NOT NULL,
	[TranLog] [char](255) NOT NULL,
	[TranOutput] [char](255) NOT NULL,
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
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [DecPlPct]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [DecPlPrcCst]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [DecPlqty]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [DeleteDta]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [EmailAddr]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [EmailRptLevel]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [EngineIn]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [EngineOut]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [InDataDir]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [InTranslatorVerify]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [InvcCustomObj]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [InvcRecheck]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [InvcRunUserEXE]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [InvcTranControl]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [InvcUserEXE]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [InvcUseTI]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [LastEDIInvID]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [LastEDIPOID]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [ObjectConnectStr]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [OutDataDir]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [POCustomObj]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [PORecheck]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [PORunUserEXE]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [POTranControl]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [POUserEXE]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [POUseTI]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [SendEmail]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [TranLog]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [TranOutput]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDSetup] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
