USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJGLSORT]    Script Date: 12/21/2015 13:44:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJGLSORT](
	[amount] [float] NOT NULL,
	[cpnyId] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[data1] [char](10) NOT NULL,
	[data2] [char](30) NOT NULL,
	[drcr] [char](1) NOT NULL,
	[employee] [char](10) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[glsort_key] [int] NOT NULL,
	[li_type] [char](1) NOT NULL,
	[source_acct] [char](16) NOT NULL,
	[source_pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[trans_date] [smalldatetime] NOT NULL,
	[units] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjglsort0] PRIMARY KEY CLUSTERED 
(
	[glsort_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
