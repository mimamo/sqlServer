USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xwrk_MC_Brd_Grp]    Script Date: 12/21/2015 15:54:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_Brd_Grp](
	[clientID] [varchar](10) NULL,
	[clientDesc] [varchar](50) NULL,
	[prodID] [varchar](10) NULL,
	[prodDesc] [varchar](50) NULL,
	[POS] [varchar](20) NULL,
	[businessUnit] [varchar](50) NULL,
	[subUnit] [varchar](20) NULL,
	[brand] [varchar](20) NULL,
	[salesmarketing] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
