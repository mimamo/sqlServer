USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xInvAdjHstry]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xInvAdjHstry](
	[BilltoDate] [float] NOT NULL,
	[Deposit] [float] NOT NULL,
	[Draft_num] [char](10) NOT NULL,
	[Estimate] [float] NOT NULL,
	[Project_billwith] [char](16) NOT NULL,
	[Salestax] [float] NOT NULL,
	[TotalBTD] [float] NOT NULL,
	[Type] [char](2) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
