USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[SOLot]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOLot](
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LotSerRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgrLotSerNbr] [char](25) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[QtyShip] [float] NOT NULL,
	[QtyShipStock] [float] NOT NULL,
	[RMADisposition] [char](3) NOT NULL,
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
	[SchedRef] [char](5) NOT NULL,
	[SpecificCostID] [char](25) NOT NULL,
	[Status] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_LotSerNbr]  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_LotSerRef]  DEFAULT (' ') FOR [LotSerRef]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_MfgrLotSerNbr]  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_QtyShip]  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_QtyShipStock]  DEFAULT ((0)) FOR [QtyShipStock]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_RMADisposition]  DEFAULT (' ') FOR [RMADisposition]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_SchedRef]  DEFAULT (' ') FOR [SchedRef]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOLot] ADD  CONSTRAINT [DF_SOLot_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
