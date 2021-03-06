USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xAWrkMainDet]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAWrkMainDet](
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
	[FieldName] [char](50) NOT NULL,
	[FieldValueBefore] [char](50) NULL,
	[FieldValueAfter] [char](50) NULL,
	[Changed] [char](1) NULL,
	[AComboKey] [varchar](255) NOT NULL,
	[LineNbr] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_GuID]  DEFAULT (' ') FOR [GuID]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_APrevTS]  DEFAULT ('0') FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_ACurrTS]  DEFAULT ('0') FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditTableName]  DEFAULT (' ') FOR [AuditTableName]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditSolomonUserID]  DEFAULT (' ') FOR [AuditSolomonUserID]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditSqlUserID]  DEFAULT (' ') FOR [AuditSqlUserID]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditComputerName]  DEFAULT (' ') FOR [AuditComputerName]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditDate]  DEFAULT ('1/1/1900') FOR [AuditDate]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditTime]  DEFAULT (' ') FOR [AuditTime]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditProcess]  DEFAULT (' ') FOR [AuditProcess]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AuditApplication]  DEFAULT (' ') FOR [AuditApplication]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_FieldName]  DEFAULT (' ') FOR [FieldName]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_FieldValueBefore]  DEFAULT (' ') FOR [FieldValueBefore]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_FieldValueAfter]  DEFAULT (' ') FOR [FieldValueAfter]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_Changed]  DEFAULT ('N') FOR [Changed]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_AComboKey]  DEFAULT (' ') FOR [AComboKey]
GO
ALTER TABLE [dbo].[xAWrkMainDet] ADD  CONSTRAINT [DF_xAWrkMainDet_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
