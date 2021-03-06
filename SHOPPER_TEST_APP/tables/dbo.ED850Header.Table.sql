USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[ED850Header]    Script Date: 12/21/2015 16:06:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850Header](
	[AckType] [char](2) NOT NULL,
	[BackOrderFlag] [smallint] NOT NULL,
	[BillToAdd1] [char](55) NOT NULL,
	[BillToAdd2] [char](55) NOT NULL,
	[BillToAdd3] [char](55) NOT NULL,
	[BillToAdd4] [char](55) NOT NULL,
	[BillToCity] [char](30) NOT NULL,
	[BillToCountry] [char](3) NOT NULL,
	[BillToName] [char](60) NOT NULL,
	[BillToName2] [char](60) NOT NULL,
	[BillToNbr] [char](80) NOT NULL,
	[BillToState] [char](2) NOT NULL,
	[BillToZip] [char](15) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryOrderTotal] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTermsDefAmtDue] [float] NOT NULL,
	[CuryTermsDiscAmt] [float] NOT NULL,
	[CustID] [char](20) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[FOBDesc] [char](80) NOT NULL,
	[FOBLocQual] [char](2) NOT NULL,
	[FOBShipMeth] [char](2) NOT NULL,
	[FOBTranTermCode] [char](3) NOT NULL,
	[FOBTranTermQual] [char](2) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NbrLines] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrderTotal] [float] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[PONbr] [char](35) NOT NULL,
	[POType] [char](2) NOT NULL,
	[PurposeCode] [char](2) NOT NULL,
	[ReleaseNbr] [char](35) NOT NULL,
	[Routing] [char](50) NOT NULL,
	[RoutingIDCode] [char](80) NOT NULL,
	[RoutingIDQual] [char](3) NOT NULL,
	[RoutingSeqCode] [char](3) NOT NULL,
	[ShipFromName] [char](80) NOT NULL,
	[ShipFromWhs] [char](80) NOT NULL,
	[ShipStatCode] [char](2) NOT NULL,
	[ShipToAdd1] [char](55) NOT NULL,
	[ShipToAdd2] [char](55) NOT NULL,
	[ShipToAdd3] [char](55) NOT NULL,
	[ShipToAdd4] [char](55) NOT NULL,
	[ShipToCity] [char](30) NOT NULL,
	[ShipToCountry] [char](3) NOT NULL,
	[ShipToName] [char](60) NOT NULL,
	[ShipToName2] [char](60) NOT NULL,
	[ShipToNbr] [char](80) NOT NULL,
	[ShipToState] [char](2) NOT NULL,
	[ShipToZip] [char](15) NOT NULL,
	[SolShipToNbr] [char](10) NOT NULL,
	[TermsBasisCode] [char](2) NOT NULL,
	[TermsDayMonth] [smallint] NOT NULL,
	[TermsDefAmtDue] [float] NOT NULL,
	[TermsDefDueDate] [smalldatetime] NOT NULL,
	[TermsDesc] [char](80) NOT NULL,
	[TermsDiscAmt] [float] NOT NULL,
	[TermsDiscDaysDue] [smallint] NOT NULL,
	[TermsDiscDueDate] [smalldatetime] NOT NULL,
	[TermsDiscNetDueDate] [smalldatetime] NOT NULL,
	[TermsDiscPerc] [float] NOT NULL,
	[TermsNetDays] [smallint] NOT NULL,
	[TermsPayMethCode] [char](2) NOT NULL,
	[TermsPercPay] [float] NOT NULL,
	[TermsTypeCode] [char](3) NOT NULL,
	[TranDirCode] [char](3) NOT NULL,
	[TranLocID] [char](30) NOT NULL,
	[TranLocQual] [char](2) NOT NULL,
	[TranMethCode] [char](3) NOT NULL,
	[TranTime] [char](6) NOT NULL,
	[TranTimeQual] [char](3) NOT NULL,
	[UpdateStatus] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [AckType]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [BackOrderFlag]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToAdd1]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToAdd2]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToAdd3]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToAdd4]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToCity]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToCountry]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToName]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToName2]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToNbr]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToState]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [BillToZip]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [CuryOrderTotal]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [CuryTermsDefAmtDue]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [CuryTermsDiscAmt]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [FOBDesc]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [FOBShipMeth]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [FOBTranTermCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [FOBTranTermQual]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [NbrLines]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [OrderTotal]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [POType]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [PurposeCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ReleaseNbr]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [Routing]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [RoutingIDCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [RoutingIDQual]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [RoutingSeqCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipFromName]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipFromWhs]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipStatCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToAdd1]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToAdd2]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToAdd3]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToAdd4]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToCity]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToCountry]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToName]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToName2]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToNbr]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToState]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [ShipToZip]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [SolShipToNbr]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TermsBasisCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsDayMonth]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsDefAmtDue]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ('01/01/1900') FOR [TermsDefDueDate]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TermsDesc]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsDiscAmt]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsDiscDaysDue]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ('01/01/1900') FOR [TermsDiscDueDate]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ('01/01/1900') FOR [TermsDiscNetDueDate]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsDiscPerc]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsNetDays]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TermsPayMethCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT ((0)) FOR [TermsPercPay]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TermsTypeCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TranDirCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TranLocID]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TranLocQual]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TranMethCode]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TranTime]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [TranTimeQual]
GO
ALTER TABLE [dbo].[ED850Header] ADD  DEFAULT (' ') FOR [UpdateStatus]
GO
