USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSBrokerFees]    Script Date: 12/21/2015 16:12:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSBrokerFees](
	[BrokerCode] [char](15) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndPeriod] [char](6) NOT NULL,
	[FeePerc] [float] NOT NULL,
	[LineId] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[StartPeriod] [char](6) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [BrokerCode]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [EndPeriod]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ((0.00)) FOR [FeePerc]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [StartPeriod]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSBrokerFees] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
