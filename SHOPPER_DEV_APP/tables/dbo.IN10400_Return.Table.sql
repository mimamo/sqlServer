USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[IN10400_Return]    Script Date: 12/21/2015 14:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10400_Return](
	[BatchType] [char](1) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[COGSBatchCreated] [smallint] NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[MsgID] [int] IDENTITY(1,1) NOT NULL,
	[MsgNbr] [smallint] NOT NULL,
	[MsgType] [char](1) NOT NULL,
	[Parm00] [char](30) NOT NULL,
	[Parm01] [char](30) NOT NULL,
	[Parm02] [char](30) NOT NULL,
	[Parm03] [char](30) NOT NULL,
	[Parm04] [char](30) NOT NULL,
	[Parm05] [char](30) NOT NULL,
	[ParmCnt] [smallint] NOT NULL,
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
	[SQLErrorNbr] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [BatchType]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [COGSBatchCreated]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [MsgNbr]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [MsgType]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [Parm00]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [Parm01]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [Parm02]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [Parm03]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [Parm04]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [Parm05]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [ParmCnt]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IN10400_Return] ADD  DEFAULT ((0)) FOR [SQLErrorNbr]
GO
