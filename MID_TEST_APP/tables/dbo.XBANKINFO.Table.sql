USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[XBANKINFO]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XBANKINFO](
	[ABA] [char](20) NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[BankAcctNum] [char](30) NOT NULL,
	[BankLimit] [float] NOT NULL,
	[BankName] [char](30) NOT NULL,
	[BankReqSig2] [smallint] NOT NULL,
	[City] [char](20) NOT NULL,
	[CnyAddr1] [char](30) NOT NULL,
	[CnyAddr2] [char](30) NOT NULL,
	[CnyCity] [char](20) NOT NULL,
	[CnyId] [char](10) NOT NULL,
	[CnyLogo] [char](255) NOT NULL,
	[CnyName] [char](60) NOT NULL,
	[CnyState] [char](2) NOT NULL,
	[CnyZip] [char](10) NOT NULL,
	[OnUsField] [char](30) NOT NULL,
	[prtLine1] [smallint] NOT NULL,
	[RTNum] [char](11) NOT NULL,
	[Signature1] [char](255) NOT NULL,
	[Signature1always] [smallint] NOT NULL,
	[Signature1Limit] [float] NOT NULL,
	[Signature2] [char](255) NOT NULL,
	[Signature2Limit] [float] NOT NULL,
	[Signature2Valid] [smallint] NOT NULL,
	[Signature2ValidMsg] [char](75) NOT NULL,
	[State] [char](2) NOT NULL,
	[SubAcct] [char](24) NOT NULL,
	[User1] [char](40) NOT NULL,
	[User2] [char](40) NOT NULL,
	[User3] [char](15) NOT NULL,
	[User4] [char](10) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Void] [smallint] NOT NULL,
	[VoidMsg] [char](50) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
