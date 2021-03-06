USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[CSStatement]    Script Date: 12/21/2015 16:12:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSStatement](
	[BatNbr] [char](10) NOT NULL,
	[CommPerNbr] [char](6) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryStmntTotal] [float] NOT NULL,
	[CycleID] [char](10) NOT NULL,
	[DrawAmt] [float] NOT NULL,
	[DrawRecover] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
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
	[SlsperID] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StmntDate] [smalldatetime] NOT NULL,
	[StmntFormat] [char](10) NOT NULL,
	[StmntID] [char](10) NOT NULL,
	[StmntTotal] [float] NOT NULL,
	[TranCntr] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [CommPerNbr]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [CuryStmntTotal]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [CycleID]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [DrawAmt]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [DrawRecover]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [StmntDate]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [StmntFormat]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [StmntID]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [StmntTotal]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [TranCntr]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CSStatement] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
