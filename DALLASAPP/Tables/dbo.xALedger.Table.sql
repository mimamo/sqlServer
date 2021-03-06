USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xALedger]    Script Date: 12/21/2015 13:44:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xALedger](
	[AID] [int] IDENTITY(1001,1) NOT NULL,
	[ASolomonUserID] [char](47) NOT NULL,
	[ASqlUserID] [char](50) NOT NULL,
	[AComputerName] [char](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [char](40) NOT NULL,
	[BalanceType] [char](1) NULL,
	[BalRequired] [smallint] NULL,
	[BaseCuryID] [char](4) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [char](8) NULL,
	[Crtd_User] [char](10) NULL,
	[Descr] [char](30) NULL,
	[LedgerID] [char](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [char](8) NULL,
	[LUpd_User] [char](10) NULL,
	[NoteID] [int] NULL,
	[S4Future01] [char](30) NULL,
	[S4Future02] [char](30) NULL,
	[S4Future03] [float] NULL,
	[S4Future04] [float] NULL,
	[S4Future05] [float] NULL,
	[S4Future06] [float] NULL,
	[S4Future07] [smalldatetime] NULL,
	[S4Future08] [smalldatetime] NULL,
	[S4Future09] [int] NULL,
	[S4Future10] [int] NULL,
	[S4Future11] [char](10) NULL,
	[S4Future12] [char](10) NULL,
	[UnitofMeas] [char](4) NULL,
	[User1] [char](30) NULL,
	[User2] [char](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [char](10) NULL,
	[User6] [char](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_ASqlUserID]  DEFAULT (CONVERT([char](50),ltrim(rtrim(user_name())),0)) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_AComputerName]  DEFAULT (CONVERT([char](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_ADate]  DEFAULT (getdate()) FOR [ADate]
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_ATime]  DEFAULT (CONVERT([char](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xALedger] ADD  CONSTRAINT [DF_xALedger_AApplication]  DEFAULT (CONVERT([char](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
