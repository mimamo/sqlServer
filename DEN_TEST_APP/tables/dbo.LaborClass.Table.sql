USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[LaborClass]    Script Date: 12/21/2015 14:10:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LaborClass](
	[CFLbrOvhRate] [float] NOT NULL,
	[CLbrOvhRate] [float] NOT NULL,
	[CPayRate] [float] NOT NULL,
	[CVLbrOvhRate] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CStdRate] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DirectLaborAC] [char](16) NOT NULL,
	[LbrClassID] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OvhLbrFixedAC] [char](16) NOT NULL,
	[OvhLbrVarAC] [char](16) NOT NULL,
	[PLbrOvhRate] [float] NOT NULL,
	[PFLbrOvhRate] [float] NOT NULL,
	[PPayRate] [float] NOT NULL,
	[PStdRate] [float] NOT NULL,
	[PVLbrOvhRate] [float] NOT NULL,
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
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_CFLbrOvhRate]  DEFAULT ((0)) FOR [CFLbrOvhRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_CLbrOvhRate]  DEFAULT ((0)) FOR [CLbrOvhRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_CPayRate]  DEFAULT ((0)) FOR [CPayRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_CVLbrOvhRate]  DEFAULT ((0)) FOR [CVLbrOvhRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_CStdRate]  DEFAULT ((0)) FOR [CStdRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_DirectLaborAC]  DEFAULT (' ') FOR [DirectLaborAC]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_LbrClassID]  DEFAULT (' ') FOR [LbrClassID]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_OvhLbrFixedAC]  DEFAULT (' ') FOR [OvhLbrFixedAC]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_OvhLbrVarAC]  DEFAULT (' ') FOR [OvhLbrVarAC]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_PLbrOvhRate]  DEFAULT ((0)) FOR [PLbrOvhRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_PFLbrOvhRate]  DEFAULT ((0)) FOR [PFLbrOvhRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_PPayRate]  DEFAULT ((0)) FOR [PPayRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_PStdRate]  DEFAULT ((0)) FOR [PStdRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_PVLbrOvhRate]  DEFAULT ((0)) FOR [PVLbrOvhRate]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[LaborClass] ADD  CONSTRAINT [DF_LaborClass_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
