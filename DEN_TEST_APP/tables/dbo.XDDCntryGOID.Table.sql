USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[XDDCntryGOID]    Script Date: 12/21/2015 14:10:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDCntryGOID](
	[Acct] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DestCntryCuryID] [char](3) NOT NULL,
	[FXIndicator] [char](2) NOT NULL,
	[GatewayOperID] [char](9) NOT NULL,
	[ISOCntry] [char](2) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
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
	[Sub] [char](24) NOT NULL,
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
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDCntryGOID0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[Acct] ASC,
	[Sub] ASC,
	[ISOCntry] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [DestCntryCuryID]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [FXIndicator]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [GatewayOperID]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [ISOCntry]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDCntryGOID] ADD  DEFAULT ('') FOR [Sub]
GO
