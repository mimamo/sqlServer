USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_MC_BaseFields]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_BaseFields](
	[Brand] [varchar](20) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[Department] [varchar](18) NULL,
	[Title] [varchar](30) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
