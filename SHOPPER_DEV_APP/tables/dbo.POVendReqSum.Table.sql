USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[POVendReqSum]    Script Date: 12/21/2015 14:33:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POVendReqSum](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[Comment] [char](60) NOT NULL,
	[Country] [char](3) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[Email] [char](80) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Output] [char](1) NOT NULL,
	[Phone] [char](30) NOT NULL,
	[QuoteAmt] [float] NOT NULL,
	[QuoteNbr] [char](10) NOT NULL,
	[ReqCntr] [char](2) NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
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
	[State] [char](3) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VOC] [char](1) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Attn]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Comment]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Email]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Output]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [QuoteAmt]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [QuoteNbr]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [ReqCntr]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [VOC]
GO
ALTER TABLE [dbo].[POVendReqSum] ADD  DEFAULT (' ') FOR [Zip]
GO
