USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[Wrk10400_GLTran]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk10400_GLTran](
	[Acct] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CrAmt] [float] NOT NULL,
	[DrAmt] [float] NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[JrnlType] [char](3) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Module] [char](2) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RefNbr] [char](15) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[TranType] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_CrAmt]  DEFAULT ((0)) FOR [CrAmt]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_DrAmt]  DEFAULT ((0)) FOR [DrAmt]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_DrCr]  DEFAULT (' ') FOR [DrCr]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_JrnlType]  DEFAULT (' ') FOR [JrnlType]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_Module]  DEFAULT (' ') FOR [Module]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_RefNbr]  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_Sub]  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_TranDate]  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_TranDesc]  DEFAULT (' ') FOR [TranDesc]
GO
ALTER TABLE [dbo].[Wrk10400_GLTran] ADD  CONSTRAINT [DF_Wrk10400_GLTran_TranType]  DEFAULT (' ') FOR [TranType]
GO
