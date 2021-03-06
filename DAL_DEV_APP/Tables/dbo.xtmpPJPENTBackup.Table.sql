USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpPJPENTBackup]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpPJPENTBackup](
	[contract_type] [char](4) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[fips_num] [char](10) NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[manager1] [char](10) NOT NULL,
	[MSPData] [char](50) NOT NULL,
	[MSPInterface] [char](1) NOT NULL,
	[MSPTask_UID] [int] NOT NULL,
	[noteid] [int] NOT NULL,
	[opportunityProduct] [char](36) NOT NULL,
	[pe_id01] [char](30) NOT NULL,
	[pe_id02] [char](30) NOT NULL,
	[pe_id03] [char](16) NOT NULL,
	[pe_id04] [char](16) NOT NULL,
	[pe_id05] [char](4) NOT NULL,
	[pe_id06] [float] NOT NULL,
	[pe_id07] [float] NOT NULL,
	[pe_id08] [smalldatetime] NOT NULL,
	[pe_id09] [smalldatetime] NOT NULL,
	[pe_id10] [int] NOT NULL,
	[pe_id31] [char](30) NOT NULL,
	[pe_id32] [char](30) NOT NULL,
	[pe_id33] [char](20) NOT NULL,
	[pe_id34] [char](20) NOT NULL,
	[pe_id35] [char](10) NOT NULL,
	[pe_id36] [char](10) NOT NULL,
	[pe_id37] [char](4) NOT NULL,
	[pe_id38] [float] NOT NULL,
	[pe_id39] [smalldatetime] NOT NULL,
	[pe_id40] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[pjt_entity_desc] [char](30) NOT NULL,
	[project] [char](16) NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[status_08] [char](1) NOT NULL,
	[status_09] [char](1) NOT NULL,
	[status_10] [char](1) NOT NULL,
	[status_11] [char](1) NOT NULL,
	[status_12] [char](1) NOT NULL,
	[status_13] [char](1) NOT NULL,
	[status_14] [char](1) NOT NULL,
	[status_15] [char](1) NOT NULL,
	[status_16] [char](1) NOT NULL,
	[status_17] [char](1) NOT NULL,
	[status_18] [char](1) NOT NULL,
	[status_19] [char](1) NOT NULL,
	[status_20] [char](1) NOT NULL,
	[status_ap] [char](1) NOT NULL,
	[status_ar] [char](1) NOT NULL,
	[status_gl] [char](1) NOT NULL,
	[status_in] [char](1) NOT NULL,
	[status_lb] [char](1) NOT NULL,
	[status_pa] [char](1) NOT NULL,
	[status_po] [char](1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
