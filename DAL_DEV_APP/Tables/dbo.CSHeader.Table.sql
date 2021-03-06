USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[CSHeader]    Script Date: 12/21/2015 13:35:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSHeader](
	[CalcExpl] [char](255) NOT NULL,
	[CommAmt] [float] NOT NULL,
	[CommRate] [float] NOT NULL,
	[CommTotal] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCommAmt] [float] NOT NULL,
	[CuryCommTotal] [float] NOT NULL,
	[CuryDocTotal] [float] NOT NULL,
	[CuryPlusAmt] [float] NOT NULL,
	[CustID] [char](15) NOT NULL,
	[DocDate] [smalldatetime] NOT NULL,
	[DocDesc] [char](30) NOT NULL,
	[DocTotal] [float] NOT NULL,
	[DocType] [char](1) NOT NULL,
	[InvcNbr] [char](10) NOT NULL,
	[LineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NetCommPct] [float] NOT NULL,
	[NetGMPct] [float] NOT NULL,
	[NetSplitPct] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[PlusAmt] [float] NOT NULL,
	[PlusMult] [float] NOT NULL,
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
	[Status] [char](1) NOT NULL,
	[StmntID] [char](10) NOT NULL,
	[TotExtCost] [float] NOT NULL,
	[TotExtPrice] [float] NOT NULL,
	[TranRef] [char](5) NOT NULL,
	[TranType] [char](2) NOT NULL,
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
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CalcExpl]  DEFAULT (' ') FOR [CalcExpl]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CommAmt]  DEFAULT ((0)) FOR [CommAmt]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CommRate]  DEFAULT ((0)) FOR [CommRate]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CommTotal]  DEFAULT ((0)) FOR [CommTotal]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CuryCommAmt]  DEFAULT ((0)) FOR [CuryCommAmt]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CuryCommTotal]  DEFAULT ((0)) FOR [CuryCommTotal]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CuryDocTotal]  DEFAULT ((0)) FOR [CuryDocTotal]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CuryPlusAmt]  DEFAULT ((0)) FOR [CuryPlusAmt]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_DocDate]  DEFAULT ('01/01/1900') FOR [DocDate]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_DocDesc]  DEFAULT (' ') FOR [DocDesc]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_DocTotal]  DEFAULT ((0)) FOR [DocTotal]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_DocType]  DEFAULT (' ') FOR [DocType]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_InvcNbr]  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_LineCntr]  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_NetCommPct]  DEFAULT ((0)) FOR [NetCommPct]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_NetGMPct]  DEFAULT ((0)) FOR [NetGMPct]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_NetSplitPct]  DEFAULT ((0)) FOR [NetSplitPct]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_PlusAmt]  DEFAULT ((0)) FOR [PlusAmt]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_PlusMult]  DEFAULT ((0)) FOR [PlusMult]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_StmntID]  DEFAULT (' ') FOR [StmntID]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_TotExtCost]  DEFAULT ((0)) FOR [TotExtCost]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_TotExtPrice]  DEFAULT ((0)) FOR [TotExtPrice]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_TranRef]  DEFAULT (' ') FOR [TranRef]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_TranType]  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CSHeader] ADD  CONSTRAINT [DF_CSHeader_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
