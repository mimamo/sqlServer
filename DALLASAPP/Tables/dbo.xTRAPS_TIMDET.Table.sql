USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xTRAPS_TIMDET]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_TIMDET](
	[docnbr] [nchar](10) NOT NULL,
	[employee] [nchar](10) NOT NULL,
	[elapsed_time] [nchar](10) NOT NULL,
	[ot1_hours] [float] NOT NULL,
	[ot2_hours] [float] NOT NULL,
	[pjt_entity] [nchar](32) NOT NULL,
	[project] [nchar](16) NOT NULL,
	[reg_hours] [float] NOT NULL,
	[tl_date] [smalldatetime] NOT NULL,
	[tl_id17] [nchar](10) NOT NULL,
	[trigger_status] [nchar](10) NOT NULL,
	[linenbr] [int] NULL
) ON [PRIMARY]
GO
