USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xaptranex]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xaptranex](
	[Acct] [char](10) NOT NULL,
	[BatnbrAP] [char](10) NOT NULL,
	[BatnbrGL] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RecordID] [int] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Released] [char](2) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TaxCat] [char](30) NOT NULL,
	[TaxIdDflt] [char](10) NOT NULL,
	[TaxIndID] [char](10) NOT NULL,
	[TaxRate] [float] NOT NULL,
	[TaxPrice] [float] NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
