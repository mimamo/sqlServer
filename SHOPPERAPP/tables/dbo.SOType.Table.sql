USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[SOType]    Script Date: 12/21/2015 16:12:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOType](
	[Active] [smallint] NOT NULL,
	[ARAcct] [char](10) NOT NULL,
	[ARSub] [char](31) NOT NULL,
	[AssemblyOnSat] [smallint] NOT NULL,
	[AssemblyOnSun] [smallint] NOT NULL,
	[AutoReleaseReturns] [smallint] NOT NULL,
	[Behavior] [char](4) NOT NULL,
	[CancelDays] [smallint] NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](31) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DiscAcct] [char](10) NOT NULL,
	[DiscSub] [char](31) NOT NULL,
	[Disp] [char](3) NOT NULL,
	[EnterLotSer] [smallint] NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtSub] [char](31) NOT NULL,
	[InvAcct] [char](10) NOT NULL,
	[InvcNbrAR] [smallint] NOT NULL,
	[InvcNbrPrefix] [char](15) NOT NULL,
	[InvcNbrType] [char](4) NOT NULL,
	[InvSub] [char](31) NOT NULL,
	[LastInvcNbr] [char](10) NOT NULL,
	[LastOrdNbr] [char](10) NOT NULL,
	[LastShipperNbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MiscAcct] [char](10) NOT NULL,
	[MiscSub] [char](31) NOT NULL,
	[NoAutoCreateShippers] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbrPrefix] [char](15) NOT NULL,
	[OrdNbrType] [char](4) NOT NULL,
	[RequireDetailAppr] [smallint] NOT NULL,
	[RequireManRelease] [smallint] NOT NULL,
	[RequireTechAppr] [smallint] NOT NULL,
	[ReturnOrderTypeID] [char](4) NOT NULL,
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
	[ShipperPrefix] [char](15) NOT NULL,
	[ShipperType] [char](4) NOT NULL,
	[ShiptoType] [char](1) NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsSub] [char](31) NOT NULL,
	[SOTypeID] [char](4) NOT NULL,
	[StdOrdType] [smallint] NOT NULL,
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
	[WholeOrdDiscAcct] [char](10) NOT NULL,
	[WholeOrdDiscSub] [char](31) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [ARAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [ARSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [AssemblyOnSat]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [AssemblyOnSun]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [AutoReleaseReturns]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [Behavior]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [CancelDays]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [Disp]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [EnterLotSer]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [InvAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [InvcNbrAR]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [InvcNbrPrefix]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [InvcNbrType]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [InvSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [LastInvcNbr]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [LastOrdNbr]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [LastShipperNbr]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [MiscAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [MiscSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [NoAutoCreateShippers]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [OrdNbrPrefix]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [OrdNbrType]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [RequireDetailAppr]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [RequireManRelease]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [RequireTechAppr]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [ReturnOrderTypeID]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [ShipperPrefix]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [ShipperType]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [ShiptoType]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [StdOrdType]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [WholeOrdDiscAcct]
GO
ALTER TABLE [dbo].[SOType] ADD  DEFAULT (' ') FOR [WholeOrdDiscSub]
GO
