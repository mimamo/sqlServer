USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[WrkPost]    Script Date: 12/21/2015 15:54:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkPost](
	[BatNbr] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[UserAddress] [char](21) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
