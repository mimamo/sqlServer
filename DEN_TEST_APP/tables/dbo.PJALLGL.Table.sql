USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PJALLGL]    Script Date: 12/21/2015 14:10:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJALLGL](
	[alloc_batch] [char](10) NOT NULL,
	[amount] [float] NOT NULL,
	[cpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[data1] [char](10) NOT NULL,
	[data2] [char](30) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[glsort_key] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[source_project] [char](16) NOT NULL,
	[source_pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[units] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjallgl0] PRIMARY KEY NONCLUSTERED 
(
	[alloc_batch] ASC,
	[glsort_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
