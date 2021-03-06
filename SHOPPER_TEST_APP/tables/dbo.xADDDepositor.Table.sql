USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xADDDepositor]    Script Date: 12/21/2015 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xADDDepositor](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[AcctType00] [varchar](1) NULL,
	[AcctType01] [varchar](1) NULL,
	[AcctType02] [varchar](1) NULL,
	[AcctType03] [varchar](1) NULL,
	[AcctType04] [varchar](1) NULL,
	[AcctType05] [varchar](1) NULL,
	[Amount00] [float] NULL,
	[Amount01] [float] NULL,
	[Amount02] [float] NULL,
	[Amount03] [float] NULL,
	[Amount04] [float] NULL,
	[BankAcct00] [varchar](17) NULL,
	[BankAcct01] [varchar](17) NULL,
	[BankAcct02] [varchar](17) NULL,
	[BankAcct03] [varchar](17) NULL,
	[BankAcct04] [varchar](17) NULL,
	[BankAcct05] [varchar](17) NULL,
	[BankID] [varchar](6) NULL,
	[BankTransit00] [varchar](9) NULL,
	[BankTransit01] [varchar](9) NULL,
	[BankTransit02] [varchar](9) NULL,
	[BankTransit03] [varchar](9) NULL,
	[BankTransit04] [varchar](9) NULL,
	[BankTransit05] [varchar](9) NULL,
	[CpnyID] [varchar](10) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[DistType] [varchar](1) NULL,
	[EmpID] [varchar](10) NULL,
	[LowPay] [varchar](1) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[NoteID] [int] NULL,
	[PNStatus00] [varchar](1) NULL,
	[PNStatus01] [varchar](1) NULL,
	[PNStatus02] [varchar](1) NULL,
	[PNStatus03] [varchar](1) NULL,
	[PNStatus04] [varchar](1) NULL,
	[PNStatus05] [varchar](1) NULL,
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
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),0)) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xADDDepositor] ADD  CONSTRAINT [DF_xADDDepositor_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
