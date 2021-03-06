USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSFATangReturn_AlterTable]    Script Date: 12/21/2015 13:44:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATangReturn_AlterTable](
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[BusDBA] [char](30) NOT NULL,
	[BusName] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Email] [char](30) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[FiscYrFrom] [char](4) NOT NULL,
	[FiscYrTo] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[OwnerName] [char](100) NOT NULL,
	[Phone] [char](30) NOT NULL,
	[SqFt] [char](60) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[State] [char](2) NOT NULL,
	[TradeAgricult] [smallint] NOT NULL,
	[TradeLease] [smallint] NOT NULL,
	[TradeManufact] [smallint] NOT NULL,
	[TradeOther] [smallint] NOT NULL,
	[TradeProf] [smallint] NOT NULL,
	[TradeRetail] [smallint] NOT NULL,
	[TradeService] [smallint] NOT NULL,
	[TradeWholesale] [smallint] NOT NULL,
	[TypeBusiness] [char](30) NOT NULL,
	[TypeService] [char](30) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [BusDBA]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [BusName]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Fax]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [FiscYrFrom]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [FiscYrTo]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [OwnerName]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [SqFt]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeAgricult]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeLease]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeManufact]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeOther]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeProf]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeRetail]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeService]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TradeWholesale]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [TypeBusiness]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [TypeService]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFATangReturn_AlterTable] ADD  DEFAULT ('') FOR [Zip]
GO
