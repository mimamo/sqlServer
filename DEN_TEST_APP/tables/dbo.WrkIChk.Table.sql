USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkIChk]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkIChk](
	[Custid] [char](15) NOT NULL,
	[Cpnyid] [char](10) NOT NULL,
	[MsgID] [int] NOT NULL,
	[OldBal] [float] NOT NULL,
	[NewBal] [float] NOT NULL,
	[AdjBal] [float] NOT NULL,
	[Other] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
