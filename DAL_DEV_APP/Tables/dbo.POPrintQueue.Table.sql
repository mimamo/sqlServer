USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[POPrintQueue]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POPrintQueue](
	[CpnyID] [char](10) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[Reprint] [smallint] NOT NULL,
	[ReqCntr] [char](2) NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_Reprint]  DEFAULT ((0)) FOR [Reprint]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_ReqCntr]  DEFAULT (' ') FOR [ReqCntr]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_ReqNbr]  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_RI_ID]  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POPrintQueue] ADD  CONSTRAINT [DF_POPrintQueue_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
