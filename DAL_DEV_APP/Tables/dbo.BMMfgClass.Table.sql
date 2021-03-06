USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[BMMfgClass]    Script Date: 12/21/2015 13:34:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BMMfgClass](
	[CFMtlOvhRate] [float] NOT NULL,
	[CMtlOvhRate] [float] NOT NULL,
	[CVMtlOvhRate] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DirectMtlAC] [char](16) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgClassID] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OvhMtlFixedAC] [char](16) NOT NULL,
	[OvhMtlVarAC] [char](16) NOT NULL,
	[PFMtlOvhRate] [float] NOT NULL,
	[PMtlOvhRate] [float] NOT NULL,
	[PVMtlOvhRate] [float] NOT NULL,
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
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_CFMtlOvhRate]  DEFAULT ((0)) FOR [CFMtlOvhRate]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_CMtlOvhRate]  DEFAULT ((0)) FOR [CMtlOvhRate]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_CVMtlOvhRate]  DEFAULT ((0)) FOR [CVMtlOvhRate]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_DirectMtlAC]  DEFAULT (' ') FOR [DirectMtlAC]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_MfgClassID]  DEFAULT (' ') FOR [MfgClassID]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_OvhMtlFixedAC]  DEFAULT (' ') FOR [OvhMtlFixedAC]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_OvhMtlVarAC]  DEFAULT (' ') FOR [OvhMtlVarAC]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_PFMtlOvhRate]  DEFAULT ((0)) FOR [PFMtlOvhRate]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_PMtlOvhRate]  DEFAULT ((0)) FOR [PMtlOvhRate]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_PVMtlOvhRate]  DEFAULT ((0)) FOR [PVMtlOvhRate]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User10]  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[BMMfgClass] ADD  CONSTRAINT [DF_BMMfgClass_User9]  DEFAULT (' ') FOR [User9]
GO
