USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkRelease]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkRelease](
	[BatNbr] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[UserAddress] [char](21) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkRelease0] PRIMARY KEY CLUSTERED 
(
	[BatNbr] ASC,
	[Module] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
