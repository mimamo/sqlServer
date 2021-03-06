USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[RptExtra]    Script Date: 12/21/2015 14:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RptExtra](
	[RI_ID] [smallint] NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[DatabaseName] [char](20) NOT NULL,
	[UserID] [char](47) NOT NULL,
	[parameters] [image] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
