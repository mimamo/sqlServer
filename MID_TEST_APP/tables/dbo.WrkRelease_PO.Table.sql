USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkRelease_PO]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkRelease_PO](
	[BatNbr] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[UserAddress] [char](21) NOT NULL,
	[PPVBatNbr] [char](10) NOT NULL,
	[PPVCount] [smallint] NOT NULL,
	[PPVRefNbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
