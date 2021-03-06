USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xASetupLog]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xASetupLog](
	[AID] [int] IDENTITY(1001,1) NOT NULL,
	[ASolomonUserID] [char](47) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[Module] [char](4) NOT NULL,
	[TableName] [char](20) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xASetupLog] ADD  CONSTRAINT [DF_xASetupLog_ASolomonUserID]  DEFAULT ('''') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xASetupLog] ADD  CONSTRAINT [DF_xASetupLog_ADate]  DEFAULT (getdate()) FOR [ADate]
GO
ALTER TABLE [dbo].[xASetupLog] ADD  CONSTRAINT [DF_xASetupLog_ATime]  DEFAULT (CONVERT([char](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xASetupLog] ADD  CONSTRAINT [DF_xASetupLog_AProcess]  DEFAULT ('''') FOR [AProcess]
GO
ALTER TABLE [dbo].[xASetupLog] ADD  CONSTRAINT [DF_xASetupLog_Module]  DEFAULT ('''') FOR [Module]
GO
ALTER TABLE [dbo].[xASetupLog] ADD  CONSTRAINT [DF_xASetupLog_TableName]  DEFAULT ('''') FOR [TableName]
GO
