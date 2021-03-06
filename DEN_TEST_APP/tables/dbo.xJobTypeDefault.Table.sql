USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xJobTypeDefault]    Script Date: 12/21/2015 14:10:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJobTypeDefault](
	[alloc_method_cd] [char](4) NOT NULL,
	[bill_type_cd] [char](4) NOT NULL,
	[copy_num] [smallint] NULL,
	[inv_attach_cd] [char](2) NOT NULL,
	[inv_Format_cd] [char](2) NOT NULL,
	[JobType] [char](4) NOT NULL,
	[labor_gl_acct] [char](10) NOT NULL,
	[rate_table_id] [char](4) NOT NULL,
	[rate_table_labor] [char](4) NOT NULL,
	[Product] [char](4) NOT NULL,
	[Status_ap] [char](1) NOT NULL,
	[Status_ar] [char](1) NOT NULL,
	[Status_gl] [char](1) NOT NULL,
	[Status_in] [char](1) NOT NULL,
	[Status_lb] [char](1) NOT NULL,
	[Status_pa] [char](1) NOT NULL,
	[Status_po] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
