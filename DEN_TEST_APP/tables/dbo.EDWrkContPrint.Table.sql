USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[EDWrkContPrint]    Script Date: 12/21/2015 14:10:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDWrkContPrint](
	[AccessNbr] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustOrdNbr] [char](25) NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
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
	[Selected] [smallint] NOT NULL,
	[ShipDateAct] [smalldatetime] NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[ShiptoID] [char](10) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_AccessNbr]  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_CustOrdNbr]  DEFAULT (' ') FOR [CustOrdNbr]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_ShipDateAct]  DEFAULT ('01/01/1900') FOR [ShipDateAct]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_ShiptoID]  DEFAULT (' ') FOR [ShiptoID]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_ShipViaID]  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDWrkContPrint] ADD  CONSTRAINT [DF_EDWrkContPrint_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
