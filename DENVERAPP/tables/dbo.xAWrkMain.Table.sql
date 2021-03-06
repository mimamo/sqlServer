USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xAWrkMain]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAWrkMain](
	[GuID] [char](32) NOT NULL,
	[APrevTS] [char](32) NOT NULL,
	[ACurrTS] [char](32) NOT NULL,
	[AuditTableName] [char](20) NOT NULL,
	[AuditSolomonUserID] [char](47) NOT NULL,
	[AuditSqlUserID] [char](50) NOT NULL,
	[AuditComputerName] [char](50) NOT NULL,
	[AuditDate] [smalldatetime] NOT NULL,
	[AuditTime] [char](12) NOT NULL,
	[AuditProcess] [char](1) NOT NULL,
	[AuditApplication] [char](40) NOT NULL,
	[AComboKey] [varchar](255) NOT NULL,
	[LineNbr] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_GuID]  DEFAULT (' ') FOR [GuID]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_APrevTS]  DEFAULT ('0') FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_ACurrTS]  DEFAULT ('0') FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditTableName]  DEFAULT (' ') FOR [AuditTableName]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditSolomonUserID]  DEFAULT (' ') FOR [AuditSolomonUserID]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditSqlUserID]  DEFAULT (' ') FOR [AuditSqlUserID]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditComputerName]  DEFAULT (' ') FOR [AuditComputerName]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditDate]  DEFAULT ('1/1/1900') FOR [AuditDate]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditTime]  DEFAULT (' ') FOR [AuditTime]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditProcess]  DEFAULT (' ') FOR [AuditProcess]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AuditApplication]  DEFAULT (' ') FOR [AuditApplication]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_AComboKey]  DEFAULT (' ') FOR [AComboKey]
GO
ALTER TABLE [dbo].[xAWrkMain] ADD  CONSTRAINT [DF_xAWrkMain_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
