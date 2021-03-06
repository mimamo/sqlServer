USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[RQWrkUserAcct]    Script Date: 12/21/2015 16:00:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RQWrkUserAcct](
	[RI_ID] [smallint] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[UserName] [char](30) NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Description] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
