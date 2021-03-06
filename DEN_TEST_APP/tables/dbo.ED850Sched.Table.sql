USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[ED850Sched]    Script Date: 12/21/2015 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850Sched](
	[AssignedID] [char](30) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Date1] [smalldatetime] NOT NULL,
	[Date2] [smalldatetime] NOT NULL,
	[DateTimeQual1] [char](3) NOT NULL,
	[DateTimeQual2] [char](3) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[EntityID] [char](80) NOT NULL,
	[EntityIDCode] [char](3) NOT NULL,
	[EntityIDQual] [char](3) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[Qty] [float] NOT NULL,
	[RefNbr] [char](60) NOT NULL,
	[Routing] [char](50) NOT NULL,
	[RoutingIDCode] [char](30) NOT NULL,
	[RoutingIDQual] [char](3) NOT NULL,
	[RoutingSeqCode] [char](3) NOT NULL,
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
	[ShipmentStatCode] [char](2) NOT NULL,
	[Time1] [char](8) NOT NULL,
	[Time2] [char](8) NOT NULL,
	[TranDirCode] [char](3) NOT NULL,
	[TranLocID] [char](30) NOT NULL,
	[TranLocQual] [char](2) NOT NULL,
	[TranMethType] [char](3) NOT NULL,
	[TranTime] [char](6) NOT NULL,
	[TranTimeQual] [char](3) NOT NULL,
	[UOM] [char](6) NOT NULL,
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
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_AssignedID]  DEFAULT (' ') FOR [AssignedID]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Date1]  DEFAULT ('01/01/1900') FOR [Date1]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Date2]  DEFAULT ('01/01/1900') FOR [Date2]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_DateTimeQual1]  DEFAULT (' ') FOR [DateTimeQual1]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_DateTimeQual2]  DEFAULT (' ') FOR [DateTimeQual2]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_EntityID]  DEFAULT (' ') FOR [EntityID]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_EntityIDCode]  DEFAULT (' ') FOR [EntityIDCode]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_EntityIDQual]  DEFAULT (' ') FOR [EntityIDQual]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Name]  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_RefNbr]  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Routing]  DEFAULT (' ') FOR [Routing]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_RoutingIDCode]  DEFAULT (' ') FOR [RoutingIDCode]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_RoutingIDQual]  DEFAULT (' ') FOR [RoutingIDQual]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_RoutingSeqCode]  DEFAULT (' ') FOR [RoutingSeqCode]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_ShipmentStatCode]  DEFAULT (' ') FOR [ShipmentStatCode]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Time1]  DEFAULT (' ') FOR [Time1]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_Time2]  DEFAULT (' ') FOR [Time2]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_TranDirCode]  DEFAULT (' ') FOR [TranDirCode]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_TranLocID]  DEFAULT (' ') FOR [TranLocID]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_TranLocQual]  DEFAULT (' ') FOR [TranLocQual]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_TranMethType]  DEFAULT (' ') FOR [TranMethType]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_TranTime]  DEFAULT (' ') FOR [TranTime]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_TranTimeQual]  DEFAULT (' ') FOR [TranTimeQual]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_UOM]  DEFAULT (' ') FOR [UOM]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850Sched] ADD  CONSTRAINT [DF_ED850Sched_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
