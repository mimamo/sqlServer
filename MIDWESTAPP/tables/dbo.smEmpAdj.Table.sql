USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[smEmpAdj]    Script Date: 12/21/2015 15:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smEmpAdj](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EmpAdjAmount] [float] NOT NULL,
	[EmpAdjDate] [smalldatetime] NOT NULL,
	[EmpAdjDocument] [char](10) NOT NULL,
	[EmpAdjId] [char](10) NOT NULL,
	[EmpAdjNotes] [char](30) NOT NULL,
	[EmpAdjSalesOrder] [char](10) NOT NULL,
	[EmpAdjTypeID] [char](10) NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
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
