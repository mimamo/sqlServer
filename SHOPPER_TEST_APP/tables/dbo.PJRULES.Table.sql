USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PJRULES]    Script Date: 12/21/2015 16:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRULES](
	[acct] [char](16) NOT NULL,
	[bill_type_cd] [char](4) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[li_type] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[ru_id01] [char](30) NOT NULL,
	[ru_id02] [char](16) NOT NULL,
	[ru_id03] [char](4) NOT NULL,
	[ru_id04] [char](4) NOT NULL,
	[ru_id05] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrules0] PRIMARY KEY CLUSTERED 
(
	[bill_type_cd] ASC,
	[acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
