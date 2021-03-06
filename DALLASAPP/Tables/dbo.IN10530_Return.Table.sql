USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[IN10530_Return]    Script Date: 12/21/2015 13:44:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10530_Return](
	[BatNbr] [char](10) NOT NULL,
	[Batch_Created] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_Batch_Created]  DEFAULT (' ') FOR [Batch_Created]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_ComputerName]  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_ErrorFlag]  DEFAULT (' ') FOR [ErrorFlag]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_ErrorInvtId]  DEFAULT (' ') FOR [ErrorInvtId]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_ErrorMessage]  DEFAULT (' ') FOR [ErrorMessage]
GO
ALTER TABLE [dbo].[IN10530_Return] ADD  CONSTRAINT [DF_IN10530_Return_Process_Flag]  DEFAULT (' ') FOR [Process_Flag]
GO
