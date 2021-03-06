USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xAProcesses]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAProcesses](
	[AID] [int] IDENTITY(1001,1) NOT NULL,
	[ASolomonUserID] [char](47) NOT NULL,
	[AProcessName] [char](20) NOT NULL,
	[ASqlUserID] [char](50) NOT NULL,
	[AComputerName] [char](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [char](40) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_AProcessName]  DEFAULT (' ') FOR [AProcessName]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_ASqlUserID]  DEFAULT (user_name()) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_AComputerName]  DEFAULT (host_name()) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_ADate]  DEFAULT (getdate()) FOR [ADate]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_ATime]  DEFAULT (CONVERT([char](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAProcesses] ADD  CONSTRAINT [DF_xAProcesses_AApplication]  DEFAULT (app_name()) FOR [AApplication]
GO
