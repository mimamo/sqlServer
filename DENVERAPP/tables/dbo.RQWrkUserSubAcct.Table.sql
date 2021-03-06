USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[RQWrkUserSubAcct]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RQWrkUserSubAcct](
	[RI_ID] [smallint] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[UserName] [char](30) NOT NULL,
	[SubAcct] [char](24) NOT NULL,
	[Description] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
