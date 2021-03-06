USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[SOBuildLot]    Script Date: 12/21/2015 13:44:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOBuildLot](
	[ActQty] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LotSerRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PlanQty] [float] NOT NULL,
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
	[ShipperID] [char](15) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_ActQty]  DEFAULT ((0)) FOR [ActQty]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_LotSerNbr]  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_LotSerRef]  DEFAULT (' ') FOR [LotSerRef]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_PlanQty]  DEFAULT ((0)) FOR [PlanQty]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOBuildLot] ADD  CONSTRAINT [DF_SOBuildLot_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
