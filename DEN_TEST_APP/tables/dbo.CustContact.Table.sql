USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[CustContact]    Script Date: 12/21/2015 14:10:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustContact](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[City] [char](30) NOT NULL,
	[ContactID] [char](10) NOT NULL,
	[Country] [char](3) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[EmailAddr] [char](80) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrderLimit] [float] NOT NULL,
	[Phone] [char](30) NOT NULL,
	[POReqdAmt] [float] NOT NULL,
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
	[Salut] [char](30) NOT NULL,
	[State] [char](3) NOT NULL,
	[Type] [char](2) NOT NULL,
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
	[WebSite] [char](40) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Addr1]  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Addr2]  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_City]  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_ContactID]  DEFAULT (' ') FOR [ContactID]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Country]  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_EmailAddr]  DEFAULT (' ') FOR [EmailAddr]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Fax]  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Name]  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_OrderLimit]  DEFAULT ((0)) FOR [OrderLimit]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Phone]  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_POReqdAmt]  DEFAULT ((0)) FOR [POReqdAmt]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Salut]  DEFAULT (' ') FOR [Salut]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_State]  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Type]  DEFAULT (' ') FOR [Type]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_WebSite]  DEFAULT (' ') FOR [WebSite]
GO
ALTER TABLE [dbo].[CustContact] ADD  CONSTRAINT [DF_CustContact_Zip]  DEFAULT (' ') FOR [Zip]
GO
