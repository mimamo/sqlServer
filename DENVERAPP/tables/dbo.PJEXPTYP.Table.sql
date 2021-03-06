USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PJEXPTYP]    Script Date: 12/21/2015 15:42:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEXPTYP](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[default_rate] [float] NOT NULL,
	[desc_exp] [char](40) NOT NULL,
	[ex_id01] [char](30) NOT NULL,
	[ex_id02] [char](30) NOT NULL,
	[ex_id03] [char](16) NOT NULL,
	[ex_id04] [char](16) NOT NULL,
	[ex_id05] [char](4) NOT NULL,
	[ex_id06] [float] NOT NULL,
	[ex_id07] [float] NOT NULL,
	[ex_id08] [smalldatetime] NOT NULL,
	[ex_id09] [smalldatetime] NOT NULL,
	[ex_id10] [int] NOT NULL,
	[exp_type] [char](4) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[status] [char](1) NOT NULL,
	[tax_flag] [char](1) NOT NULL,
	[taxid] [char](10) NOT NULL,
	[units_flag] [char](1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjexptyp0] PRIMARY KEY CLUSTERED 
(
	[exp_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
