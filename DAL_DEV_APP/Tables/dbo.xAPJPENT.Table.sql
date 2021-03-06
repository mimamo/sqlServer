USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xAPJPENT]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xAPJPENT](
	[AID] [int] IDENTITY(1001,1) NOT NULL,
	[ASolomonUserID] [char](47) NOT NULL,
	[ASqlUserID] [char](50) NOT NULL,
	[AComputerName] [char](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [char](40) NOT NULL,
	[contract_type] [char](4) NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [char](8) NULL,
	[crtd_user] [char](10) NULL,
	[end_date] [smalldatetime] NULL,
	[fips_num] [char](10) NULL,
	[labor_class_cd] [char](4) NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [char](8) NULL,
	[lupd_user] [char](10) NULL,
	[manager1] [char](10) NULL,
	[MSPData] [char](50) NULL,
	[MSPInterface] [char](1) NULL,
	[MSPTask_UID] [int] NULL,
	[noteid] [int] NULL,
	[opportunityProduct] [char](36) NULL,
	[pe_id01] [char](30) NULL,
	[pe_id02] [char](30) NULL,
	[pe_id03] [char](16) NULL,
	[pe_id04] [char](16) NULL,
	[pe_id05] [char](4) NULL,
	[pe_id06] [float] NULL,
	[pe_id07] [float] NULL,
	[pe_id08] [smalldatetime] NULL,
	[pe_id09] [smalldatetime] NULL,
	[pe_id10] [int] NULL,
	[pe_id31] [char](30) NULL,
	[pe_id32] [char](30) NULL,
	[pe_id33] [char](20) NULL,
	[pe_id34] [char](20) NULL,
	[pe_id35] [char](10) NULL,
	[pe_id36] [char](10) NULL,
	[pe_id37] [char](4) NULL,
	[pe_id38] [float] NULL,
	[pe_id39] [smalldatetime] NULL,
	[pe_id40] [int] NULL,
	[pjt_entity] [char](32) NULL,
	[pjt_entity_desc] [char](30) NULL,
	[project] [char](16) NULL,
	[start_date] [smalldatetime] NULL,
	[status_08] [char](1) NULL,
	[status_09] [char](1) NULL,
	[status_10] [char](1) NULL,
	[status_11] [char](1) NULL,
	[status_12] [char](1) NULL,
	[status_13] [char](1) NULL,
	[status_14] [char](1) NULL,
	[status_15] [char](1) NULL,
	[status_16] [char](1) NULL,
	[status_17] [char](1) NULL,
	[status_18] [char](1) NULL,
	[status_19] [char](1) NULL,
	[status_20] [char](1) NULL,
	[status_ap] [char](1) NULL,
	[status_ar] [char](1) NULL,
	[status_gl] [char](1) NULL,
	[status_in] [char](1) NULL,
	[status_lb] [char](1) NULL,
	[status_pa] [char](1) NULL,
	[status_po] [char](1) NULL,
	[user1] [char](30) NULL,
	[user2] [char](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_ASqlUserID]  DEFAULT (CONVERT([char](50),ltrim(rtrim(user_name())),0)) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_AComputerName]  DEFAULT (CONVERT([char](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_ADate]  DEFAULT (getdate()) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_ATime]  DEFAULT (CONVERT([char](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJPENT] ADD  CONSTRAINT [DF_xAPJPENT_AApplication]  DEFAULT (CONVERT([char](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
