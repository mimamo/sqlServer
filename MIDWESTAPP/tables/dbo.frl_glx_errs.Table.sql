USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[frl_glx_errs]    Script Date: 12/21/2015 15:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[frl_glx_errs](
	[cpnyid] [char](10) NULL,
	[acct] [char](10) NULL,
	[sub] [char](24) NULL,
	[err_date] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
