USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[XBDfltPrinter]    Script Date: 12/21/2015 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XBDfltPrinter](
	[Acct] [varchar](10) NOT NULL,
	[CpnyID] [varchar](10) NOT NULL,
	[ComputerName] [varchar](25) NOT NULL,
	[PrinterName] [varchar](255) NOT NULL,
	[PrinterPort] [varchar](255) NOT NULL,
	[SubAcct] [varchar](24) NOT NULL,
	[User1] [char](40) NOT NULL,
	[User2] [char](40) NOT NULL,
	[User3] [char](15) NOT NULL,
	[User4] [char](10) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
