USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PJPOOLB]    Script Date: 12/21/2015 14:33:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPOOLB](
	[alloc_amount_ptd] [float] NOT NULL,
	[alloc_amount_ytd] [float] NOT NULL,
	[alloc_cpnyid] [char](10) NOT NULL,
	[alloc_gl_acct] [char](10) NOT NULL,
	[alloc_gl_subacct] [char](24) NOT NULL,
	[basis_amount_ptd] [float] NOT NULL,
	[basis_amount_ytd] [float] NOT NULL,
	[basis_cpnyid] [char](10) NOT NULL,
	[basis_factor] [float] NOT NULL,
	[basis_gl_acct] [char](10) NOT NULL,
	[basis_gl_subacct] [char](24) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[grpid] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[period] [char](6) NOT NULL,
	[pb_id01] [char](30) NOT NULL,
	[pb_id02] [char](16) NOT NULL,
	[pb_id03] [float] NOT NULL,
	[pb_id04] [float] NOT NULL,
	[pb_id05] [smalldatetime] NOT NULL,
	[pb_id06] [int] NOT NULL,
	[recnbr] [int] IDENTITY(1,1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpoolb0] PRIMARY KEY CLUSTERED 
(
	[grpid] ASC,
	[period] ASC,
	[recnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
