USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PJLABSRT]    Script Date: 12/21/2015 15:42:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJLABSRT](
	[amount] [float] NOT NULL,
	[cpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[hours] [float] NOT NULL,
	[hrs_type] [char](4) NOT NULL,
	[labsrt_key] [int] NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[status_2] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjlabsrt0] PRIMARY KEY CLUSTERED 
(
	[labsrt_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
