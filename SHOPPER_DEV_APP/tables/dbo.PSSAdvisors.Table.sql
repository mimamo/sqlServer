USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSAdvisors]    Script Date: 12/21/2015 14:33:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSAdvisors](
	[AcceptsComm] [smallint] NOT NULL,
	[Addr1] [char](100) NOT NULL,
	[Addr2] [char](100) NOT NULL,
	[AdvisorBrIntNo] [char](10) NOT NULL,
	[AdvisorClNo] [char](10) NOT NULL,
	[AdvisorFName] [char](30) NOT NULL,
	[AdvisorLName] [char](30) NOT NULL,
	[AdvisorMI] [char](2) NOT NULL,
	[AdvisorNo] [char](10) NOT NULL,
	[AdvisorOrigin] [char](10) NOT NULL,
	[AdvisorPrix] [char](15) NOT NULL,
	[AdvisorSuff] [char](1) NOT NULL,
	[BrokerCode] [char](15) NOT NULL,
	[City] [char](60) NOT NULL,
	[Country] [char](100) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Email] [char](40) NOT NULL,
	[Fax] [char](10) NOT NULL,
	[FirmNo] [char](10) NOT NULL,
	[HomePhone] [char](10) NOT NULL,
	[IsActive] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[State] [char](2) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WorkPhone] [char](10) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ((0)) FOR [AcceptsComm]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorBrIntNo]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorClNo]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorFName]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorLName]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorMI]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorNo]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorOrigin]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorPrix]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [AdvisorSuff]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [BrokerCode]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Country]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Fax]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [FirmNo]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [HomePhone]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [WorkPhone]
GO
ALTER TABLE [dbo].[PSSAdvisors] ADD  DEFAULT ('') FOR [Zip]
GO
