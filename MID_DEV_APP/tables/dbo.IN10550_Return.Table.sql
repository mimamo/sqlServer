USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[IN10550_Return]    Script Date: 12/21/2015 14:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10550_Return](
	[ComputerName] [char](21) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[ErrorFlag] [char](1) NOT NULL,
	[ErrorInvtId] [char](30) NOT NULL,
	[ErrorMessage] [char](4) NOT NULL,
	[Process_Flag] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10550_Return] ADD  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[IN10550_Return] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10550_Return] ADD  DEFAULT (' ') FOR [ErrorFlag]
GO
ALTER TABLE [dbo].[IN10550_Return] ADD  DEFAULT (' ') FOR [ErrorInvtId]
GO
ALTER TABLE [dbo].[IN10550_Return] ADD  DEFAULT (' ') FOR [ErrorMessage]
GO
ALTER TABLE [dbo].[IN10550_Return] ADD  DEFAULT (' ') FOR [Process_Flag]
GO
