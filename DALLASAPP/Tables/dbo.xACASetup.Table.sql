USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xACASetup]    Script Date: 12/21/2015 13:44:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xACASetup](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[AcceptTransDate] [smalldatetime] NULL,
	[ARHoldingAcct] [varchar](10) NULL,
	[ARHoldingSub] [varchar](24) NULL,
	[AutoBatRpt] [smallint] NULL,
	[BnkChgType] [varchar](2) NULL,
	[ClearAcct] [varchar](10) NULL,
	[ClearSub] [varchar](24) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[CurrPerNbr] [varchar](6) NULL,
	[DfltRateType] [varchar](6) NULL,
	[DfltRcnclAmt] [smallint] NULL,
	[GlPostOpt] [varchar](1) NULL,
	[Init] [smallint] NULL,
	[lastbatnbr] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[MCuryBatRpt] [smallint] NULL,
	[NbrAvgDay] [smallint] NULL,
	[NoteID] [int] NULL,
	[paststartdate] [smalldatetime] NULL,
	[PerNbr] [varchar](6) NULL,
	[PerretBal] [smallint] NULL,
	[PerRetTran] [smallint] NULL,
	[PostGLDetail] [smallint] NULL,
	[PrtEmpName] [smallint] NULL,
	[S4Future01] [varchar](30) NULL,
	[S4Future02] [varchar](30) NULL,
	[S4Future03] [float] NULL,
	[S4Future04] [float] NULL,
	[S4Future05] [float] NULL,
	[S4Future06] [float] NULL,
	[S4Future07] [smalldatetime] NULL,
	[S4Future08] [smalldatetime] NULL,
	[S4Future09] [int] NULL,
	[S4Future10] [int] NULL,
	[S4Future11] [varchar](10) NULL,
	[S4Future12] [varchar](10) NULL,
	[SetUpId] [varchar](2) NULL,
	[ShowGLInfo] [smallint] NULL,
	[ShowLastBankRecs] [smallint] NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xACASetup] ADD  CONSTRAINT [DF_xACASetup_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
