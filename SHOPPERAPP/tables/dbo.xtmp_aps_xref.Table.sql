USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xtmp_aps_xref]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmp_aps_xref](
	[eparent] [nvarchar](255) NULL,
	[sl parent] [nvarchar](255) NULL,
	[new code] [nvarchar](255) NULL,
	[old code] [nvarchar](255) NULL,
	[TRAPS job] [nvarchar](255) NULL,
	[SL APS job] [nvarchar](255) NULL
) ON [PRIMARY]
GO
