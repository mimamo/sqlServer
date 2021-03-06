USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[Site]    Script Date: 12/21/2015 13:56:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Site](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[AlwaysShip] [smallint] NOT NULL,
	[Attn] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](31) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DfltInvtAcct] [char](10) NOT NULL,
	[DfltInvtSub] [char](31) NOT NULL,
	[DfltRepairBin] [char](10) NOT NULL,
	[DfltVendorBin] [char](10) NOT NULL,
	[DicsAcct] [char](10) NOT NULL,
	[DiscSub] [char](31) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtSub] [char](31) NOT NULL,
	[GeoCode] [char](10) NOT NULL,
	[IRCalcPolicy] [char](1) NOT NULL,
	[IRDaysSupply] [float] NOT NULL,
	[IRDemandID] [char](10) NOT NULL,
	[IRFutureDate] [smalldatetime] NOT NULL,
	[IRFuturePolicy] [char](1) NOT NULL,
	[IRLeadTimeID] [char](10) NOT NULL,
	[IRPrimaryVendID] [char](15) NOT NULL,
	[IRSeasonEndDay] [smallint] NOT NULL,
	[IRSeasonEndMon] [smallint] NOT NULL,
	[IRSeasonStrtDay] [smallint] NOT NULL,
	[IRSeasonStrtMon] [smallint] NOT NULL,
	[IRServiceLevel] [float] NOT NULL,
	[IRSftyStkDays] [float] NOT NULL,
	[IRSftyStkPct] [float] NOT NULL,
	[IRSftyStkPolicy] [char](1) NOT NULL,
	[IRSourceCode] [char](1) NOT NULL,
	[IRTargetOrdMethod] [char](1) NOT NULL,
	[IRTargetOrdReq] [float] NOT NULL,
	[IRTransferSiteID] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MiscAcct] [char](10) NOT NULL,
	[MiscSub] [char](31) NOT NULL,
	[Name] [char](30) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Phone] [char](30) NOT NULL,
	[ReplMthd] [char](1) NOT NULL,
	[REPWhseLoc] [char](10) NOT NULL,
	[RTVWhseLoc] [char](10) NOT NULL,
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
	[Salut] [char](30) NOT NULL,
	[SiteId] [char](10) NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsSub] [char](31) NOT NULL,
	[State] [char](3) NOT NULL,
	[Status] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VisibleForWC] [smallint] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [AlwaysShip]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Attn]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [DfltInvtAcct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [DfltInvtSub]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [DfltRepairBin]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [DfltVendorBin]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [DicsAcct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [GeoCode]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRCalcPolicy]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRDaysSupply]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRDemandID]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ('01/01/1900') FOR [IRFutureDate]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRFuturePolicy]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRLeadTimeID]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRPrimaryVendID]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRSeasonEndDay]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRSeasonEndMon]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRSeasonStrtDay]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRSeasonStrtMon]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRServiceLevel]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRSftyStkDays]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRSftyStkPct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRSftyStkPolicy]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRSourceCode]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRTargetOrdMethod]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [IRTargetOrdReq]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [IRTransferSiteID]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [MiscAcct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [MiscSub]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [ReplMthd]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [REPWhseLoc]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [RTVWhseLoc]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Salut]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [SiteId]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT ((0)) FOR [VisibleForWC]
GO
ALTER TABLE [dbo].[Site] ADD  DEFAULT (' ') FOR [Zip]
GO
