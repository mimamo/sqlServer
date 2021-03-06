USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[WOTask]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOTask](
	[CntMaterial] [smallint] NOT NULL,
	[CntRouting] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MRLineCntr] [int] NOT NULL,
	[NoteID] [int] NOT NULL,
	[ProcStage] [char](1) NOT NULL,
	[RLineCntr] [int] NOT NULL,
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
	[Task] [char](32) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_CntMaterial]  DEFAULT ((0)) FOR [CntMaterial]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_CntRouting]  DEFAULT ((0)) FOR [CntRouting]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_Crtd_Time]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_LUPd_Time]  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_MRLineCntr]  DEFAULT ((0)) FOR [MRLineCntr]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_ProcStage]  DEFAULT (' ') FOR [ProcStage]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_RLineCntr]  DEFAULT ((0)) FOR [RLineCntr]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_Task]  DEFAULT (' ') FOR [Task]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User10]  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_User9]  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOTask] ADD  CONSTRAINT [DF_WOTask_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
