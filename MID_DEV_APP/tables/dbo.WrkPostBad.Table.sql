USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkPostBad]    Script Date: 12/21/2015 14:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkPostBad](
	[BatNbr] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[Situation] [char](10) NOT NULL,
	[UserAddress] [char](21) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
