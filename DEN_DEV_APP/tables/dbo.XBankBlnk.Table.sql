USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[XBankBlnk]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XBankBlnk](
	[Account] [char](10) NOT NULL,
	[CheckNbr] [char](10) NOT NULL,
	[CnyID] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SubAcct] [char](24) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
