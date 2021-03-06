USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[XDDTaxPmt]    Script Date: 12/21/2015 13:44:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDTaxPmt](
	[Code] [char](5) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](50) NOT NULL,
	[IDNbr] [char](15) NOT NULL,
	[IDonSixRec] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Periods] [char](20) NOT NULL,
	[RecFormat] [char](1) NOT NULL,
	[Selected] [char](1) NOT NULL,
	[ShortDescr] [char](15) NOT NULL,
	[SKFuture01] [char](30) NOT NULL,
	[SKFuture02] [char](30) NOT NULL,
	[SKFuture03] [float] NOT NULL,
	[SKFuture04] [float] NOT NULL,
	[SKFuture05] [float] NOT NULL,
	[SKFuture06] [float] NOT NULL,
	[SKFuture07] [smalldatetime] NOT NULL,
	[SKFuture08] [smalldatetime] NOT NULL,
	[SKFuture09] [int] NOT NULL,
	[SKFuture10] [int] NOT NULL,
	[SKFuture11] [char](10) NOT NULL,
	[SKFuture12] [char](10) NOT NULL,
	[SubCategory] [char](5) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[Verification] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [IDonSixRec]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [RecFormat]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [SubCategory]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDTaxPmt] ADD  DEFAULT ('') FOR [User9]
GO
