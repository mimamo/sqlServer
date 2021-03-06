USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[ShipVia]    Script Date: 12/21/2015 15:54:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShipVia](
	[CarrierID] [char](10) NOT NULL,
	[CommonCarrier] [smallint] NOT NULL,
	[CompareVia] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeliveryCalendarID] [smallint] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DfltFrtAmt] [float] NOT NULL,
	[DfltFrtMthd] [char](1) NOT NULL,
	[EDIViaCode] [char](20) NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtSub] [char](31) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Mode] [char](2) NOT NULL,
	[MoveOnDeliveryDays] [smallint] NOT NULL,
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
	[SCAC] [char](5) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[TaxCat] [char](10) NOT NULL,
	[TransitTime] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WeekendDelivery] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [ShipVia0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[ShipViaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
