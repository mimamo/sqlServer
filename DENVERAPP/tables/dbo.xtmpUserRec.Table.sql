USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xtmpUserRec]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpUserRec](
	[userid] [char](10) NULL,
	[rectype] [char](10) NULL,
	[phone] [char](30) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
