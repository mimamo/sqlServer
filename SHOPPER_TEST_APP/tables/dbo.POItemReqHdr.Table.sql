USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[POItemReqHdr]    Script Date: 12/21/2015 16:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POItemReqHdr](
	[BillAddr1] [char](60) NOT NULL,
	[BillAddr2] [char](60) NOT NULL,
	[BillCity] [char](30) NOT NULL,
	[BillCountry] [char](3) NOT NULL,
	[BillEmail] [char](80) NOT NULL,
	[BillFax] [char](30) NOT NULL,
	[BillName] [char](60) NOT NULL,
	[BillPhone] [char](30) NOT NULL,
	[BillState] [char](3) NOT NULL,
	[BillZip] [char](10) NOT NULL,
	[City] [char](30) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DocHandling] [char](2) NOT NULL,
	[IrTotal] [float] NOT NULL,
	[ItemReqNbr] [char](10) NOT NULL,
	[LineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Requstnr] [char](47) NOT NULL,
	[RequstnrDept] [char](10) NOT NULL,
	[RequstnrName] [char](30) NOT NULL,
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
	[ShipAddr1] [char](60) NOT NULL,
	[ShipAddr2] [char](60) NOT NULL,
	[ShipCity] [char](30) NOT NULL,
	[ShipCountry] [char](3) NOT NULL,
	[ShipEmail] [char](80) NOT NULL,
	[ShipFax] [char](30) NOT NULL,
	[ShipName] [char](60) NOT NULL,
	[ShipPhone] [char](30) NOT NULL,
	[ShipState] [char](3) NOT NULL,
	[ShipZip] [char](10) NOT NULL,
	[State] [char](3) NOT NULL,
	[Status] [char](2) NOT NULL,
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
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillAddr1]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillAddr2]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillCity]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillCountry]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillEmail]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillFax]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillName]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillPhone]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillState]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [BillZip]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ('01/01/1900') FOR [CreateDate]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [DocHandling]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [IrTotal]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ItemReqNbr]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Requstnr]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [RequstnrDept]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [RequstnrName]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipAddr1]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipAddr2]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipCity]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipCountry]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipEmail]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipFax]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipName]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipPhone]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipState]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [ShipZip]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POItemReqHdr] ADD  DEFAULT (' ') FOR [Zip]
GO
