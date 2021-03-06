USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSBroker]    Script Date: 12/21/2015 13:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSBroker](
	[Addr1] [char](100) NOT NULL,
	[Addr2] [char](100) NOT NULL,
	[Assistant] [char](100) NOT NULL,
	[AsstPhone] [char](10) NOT NULL,
	[AsstPhoneExt] [char](10) NOT NULL,
	[BrokerCode] [char](15) NOT NULL,
	[BrokerName] [char](100) NOT NULL,
	[CheckDate] [smalldatetime] NOT NULL,
	[CheckPayTo] [char](100) NOT NULL,
	[City] [char](60) NOT NULL,
	[CommisBase] [float] NOT NULL,
	[CommisChkNo] [float] NOT NULL,
	[CommisEst] [float] NOT NULL,
	[CompName] [char](100) NOT NULL,
	[ContactName] [char](100) NOT NULL,
	[Country] [char](100) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Phone] [char](10) NOT NULL,
	[PhoneExt] [char](10) NOT NULL,
	[PrintCheck] [smallint] NOT NULL,
	[QTDCommis] [float] NOT NULL,
	[State] [char](2) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxId] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Assistant]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [AsstPhone]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [AsstPhoneExt]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [BrokerCode]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [BrokerName]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('01/01/1900') FOR [CheckDate]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [CheckPayTo]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0.00)) FOR [CommisBase]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0.00)) FOR [CommisChkNo]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0.00)) FOR [CommisEst]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [CompName]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [ContactName]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Country]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [PhoneExt]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0)) FOR [PrintCheck]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0.00)) FOR [QTDCommis]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [TaxId]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSBroker] ADD  DEFAULT ('') FOR [zip]
GO
