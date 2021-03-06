USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xTRAPS_REVCAT]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_REVCAT](
	[acct] [nchar](16) NOT NULL,
	[amount] [float] NOT NULL,
	[noteid] [int] NOT NULL,
	[pjt_entity] [nchar](32) NOT NULL,
	[project] [nchar](16) NOT NULL,
	[rate] [float] NOT NULL,
	[revid] [nchar](10) NOT NULL,
	[trigger_status] [nchar](10) NOT NULL,
	[units] [float] NOT NULL
) ON [PRIMARY]
GO
