USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xardoc]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xardoc](
	[custid] [char](15) NOT NULL,
	[name] [char](30) NOT NULL,
	[origdocamt] [float] NOT NULL,
	[Refnbr] [char](10) NOT NULL,
	[userid] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
