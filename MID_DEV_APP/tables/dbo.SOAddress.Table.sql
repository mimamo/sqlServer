USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[SOAddress]    Script Date: 12/21/2015 14:16:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOAddress](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[COGSAcct] [char](10) NOT NULL,
	[COGSSub] [char](31) NOT NULL,
	[Country] [char](3) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DiscAcct] [char](10) NOT NULL,
	[DiscSub] [char](31) NOT NULL,
	[EMailAddr] [char](80) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[FOB] [char](15) NOT NULL,
	[FrghtCode] [char](4) NOT NULL,
	[FrtAcct] [char](10) NOT NULL,
	[FrtSub] [char](31) NOT NULL,
	[FrtTermsID] [char](10) NOT NULL,
	[GeoCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MapLocation] [char](10) NOT NULL,
	[MiscAcct] [char](10) NOT NULL,
	[MiscSub] [char](31) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Phone] [char](30) NOT NULL,
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
	[ShipToId] [char](10) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsPerID] [char](10) NOT NULL,
	[SlsSub] [char](31) NOT NULL,
	[State] [char](3) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxId00] [char](10) NOT NULL,
	[TaxId01] [char](10) NOT NULL,
	[TaxId02] [char](10) NOT NULL,
	[TaxId03] [char](10) NOT NULL,
	[TaxLocId] [char](15) NOT NULL,
	[TaxRegNbr] [char](15) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [soaddress0] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[ShipToId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Attn]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [COGSAcct]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [COGSSub]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [CustId]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [DiscAcct]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [DiscSub]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [EMailAddr]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [FOB]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [FrghtCode]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [FrtAcct]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [FrtSub]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [FrtTermsID]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [GeoCode]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [MapLocation]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [MiscAcct]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [MiscSub]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [ShipToId]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [SlsPerID]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [TaxId00]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [TaxId01]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [TaxId02]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [TaxId03]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [TaxLocId]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [TaxRegNbr]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[SOAddress] ADD  DEFAULT (' ') FOR [Zip]
GO
