USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xAPOSetup]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPOSetup](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[AddAlternateID] [varchar](1) NULL,
	[AdminLeadTime] [smallint] NULL,
	[APAccrAcct] [varchar](10) NULL,
	[APAccrSub] [varchar](24) NULL,
	[AutoRef] [smallint] NULL,
	[BillAddr1] [varchar](60) NULL,
	[BillAddr2] [varchar](60) NULL,
	[BillAttn] [varchar](30) NULL,
	[BillCity] [varchar](30) NULL,
	[BillCountry] [varchar](3) NULL,
	[BillEmail] [varchar](80) NULL,
	[BillFax] [varchar](30) NULL,
	[BillName] [varchar](60) NULL,
	[BillPhone] [varchar](30) NULL,
	[BillState] [varchar](3) NULL,
	[BillZip] [varchar](10) NULL,
	[CreateAD] [smallint] NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[DecPlPrcCst] [smallint] NULL,
	[DecPlQty] [smallint] NULL,
	[DefaultAltIDType] [varchar](1) NULL,
	[DemandPeriods] [smallint] NULL,
	[DfltLstUnitCost] [varchar](1) NULL,
	[DfltRcptUnitFromIN] [smallint] NULL,
	[FrtAcct] [varchar](10) NULL,
	[FrtSub] [varchar](24) NULL,
	[HotPrintPO] [smallint] NULL,
	[INAvail] [smallint] NULL,
	[Init] [smallint] NULL,
	[InvtCarryingCost] [float] NULL,
	[LastBatNbr] [varchar](10) NULL,
	[LastPONbr] [varchar](10) NULL,
	[LastRcptNbr] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[MultPOAllowed] [smallint] NULL,
	[NonInvtAcct] [varchar](10) NULL,
	[NonInvtSub] [varchar](24) NULL,
	[NoteID] [int] NULL,
	[PCAvail] [smallint] NULL,
	[PerRetTran] [smallint] NULL,
	[PMAvail] [smallint] NULL,
	[PPVAcct] [varchar](10) NULL,
	[PPVSub] [varchar](24) NULL,
	[PrtAddr] [smallint] NULL,
	[PrtSite] [smallint] NULL,
	[ReopenPO] [smallint] NULL,
	[S4Future01] [varchar](30) NULL,
	[S4Future02] [varchar](30) NULL,
	[S4Future03] [float] NULL,
	[S4Future04] [float] NULL,
	[S4Future05] [float] NULL,
	[S4Future06] [float] NULL,
	[S4Future07] [smalldatetime] NULL,
	[S4Future08] [smalldatetime] NULL,
	[S4Future09] [int] NULL,
	[S4Future10] [int] NULL,
	[S4Future11] [varchar](10) NULL,
	[S4Future12] [varchar](10) NULL,
	[SetupCost] [float] NULL,
	[SetupID] [varchar](2) NULL,
	[ShipAddr1] [varchar](60) NULL,
	[ShipAddr2] [varchar](60) NULL,
	[ShipAttn] [varchar](30) NULL,
	[ShipCity] [varchar](30) NULL,
	[ShipCountry] [varchar](3) NULL,
	[ShipEmail] [varchar](80) NULL,
	[ShipFax] [varchar](30) NULL,
	[ShipName] [varchar](60) NULL,
	[ShipPhone] [varchar](30) NULL,
	[ShipState] [varchar](3) NULL,
	[ShipZip] [varchar](10) NULL,
	[TaxFlg] [smallint] NULL,
	[TranDescFlg] [varchar](1) NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[Vouchering] [smallint] NULL,
	[VouchQtyErr] [varchar](1) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPOSetup] ADD  CONSTRAINT [DF_xAPOSetup_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
