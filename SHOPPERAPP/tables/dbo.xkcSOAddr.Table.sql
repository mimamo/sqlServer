USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xkcSOAddr]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xkcSOAddr](
	[Custid] [char](15) NULL,
	[Linenbr] [smallint] NULL,
	[NewShipToID] [char](10) NULL,
	[OldShipToID] [char](10) NULL,
	[specid] [char](2) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
