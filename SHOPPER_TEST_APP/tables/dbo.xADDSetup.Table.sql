USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xADDSetup]    Script Date: 12/21/2015 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xADDSetup](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[ACHCompanyID] [varchar](10) NULL,
	[AchCrLf] [varchar](1) NULL,
	[ACHFileName] [varchar](255) NULL,
	[ACHFillBlock] [varchar](1) NULL,
	[ACHImmDest] [varchar](10) NULL,
	[ACHImmDestN] [varchar](23) NULL,
	[ACHImmOrig] [varchar](10) NULL,
	[ACHImmOrigN] [varchar](23) NULL,
	[ACHInclDR] [varchar](1) NULL,
	[CommMAnswer] [varchar](30) NULL,
	[CommMAttn] [varchar](30) NULL,
	[CommMBusy] [varchar](30) NULL,
	[CommMConnect] [varchar](40) NULL,
	[CommMDialPrefix] [varchar](30) NULL,
	[CommMHangUp] [varchar](50) NULL,
	[CommMHighBaud] [int] NULL,
	[CommMInit] [varchar](128) NULL,
	[CommMMake] [varchar](25) NULL,
	[CommMModel] [varchar](40) NULL,
	[CommMNum] [int] NULL,
	[CommMReset] [varchar](30) NULL,
	[CommPBaud] [int] NULL,
	[CommPCommPort] [smallint] NULL,
	[CommPDataBit] [varchar](1) NULL,
	[CommPDTR] [smallint] NULL,
	[CommPEcho] [smallint] NULL,
	[CommPHandShake] [smallint] NULL,
	[CommPhone] [varchar](30) NULL,
	[CommPParity] [varchar](1) NULL,
	[CommPRTS] [smallint] NULL,
	[CommPStopBit] [varchar](1) NULL,
	[CommPXferProto] [smallint] NULL,
	[CommType] [varchar](1) NULL,
	[CommUserProg] [varchar](255) NULL,
	[CpnyID] [varchar](10) NULL,
	[CpnyName] [varchar](30) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[DistTypeDflt] [varchar](1) NULL,
	[Init] [varchar](1) NULL,
	[LowPayDflt] [varchar](1) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[NoteID] [int] NULL,
	[PathACHScript] [varchar](255) NULL,
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
	[SetupID] [varchar](2) NULL,
	[TestMode] [varchar](1) NULL,
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
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),0)) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xADDSetup] ADD  CONSTRAINT [DF_xADDSetup_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
