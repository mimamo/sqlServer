USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[WOLotSerT]    Script Date: 12/21/2015 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOLotSerT](
	[BatNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[ExpDate] [smalldatetime] NOT NULL,
	[INTranLineRef] [char](5) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[InvtMult] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LotSerTRecordID] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgrLotSerNbr] [char](25) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PJTK_Key] [char](24) NOT NULL,
	[PJTKBatch_ID] [char](10) NOT NULL,
	[PJTKDetail_Num] [char](6) NOT NULL,
	[PJTKFiscalNo] [char](6) NOT NULL,
	[PJTKSystem_Cd] [char](2) NOT NULL,
	[Qty] [float] NOT NULL,
	[QtyTransferToDate] [float] NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
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
	[ShipContCode] [char](20) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranLineRef] [char](5) NOT NULL,
	[TranSDType] [char](2) NOT NULL,
	[TranSrcLineRef] [char](5) NOT NULL,
	[TranType] [char](5) NOT NULL,
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
	[WarrantyDate] [smalldatetime] NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [ExpDate]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [INTranLineRef]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [InvtMult]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [LotSerTRecordID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [PJTK_Key]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [PJTKBatch_ID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [PJTKDetail_Num]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [PJTKFiscalNo]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [PJTKSystem_Cd]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [QtyTransferToDate]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [ShipContCode]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [TranLineRef]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [TranSDType]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [TranSrcLineRef]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT ('01/01/1900') FOR [WarrantyDate]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[WOLotSerT] ADD  DEFAULT (' ') FOR [WONbr]
GO
