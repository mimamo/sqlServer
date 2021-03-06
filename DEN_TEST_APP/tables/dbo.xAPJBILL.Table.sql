USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xAPJBILL]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJBILL](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[approval_sw] [varchar](1) NULL,
	[approver] [varchar](10) NULL,
	[BillCuryId] [varchar](4) NULL,
	[biller] [varchar](10) NULL,
	[billings_cycle_cd] [varchar](2) NULL,
	[billings_level] [varchar](2) NULL,
	[bill_type_cd] [varchar](4) NULL,
	[copy_num] [smallint] NULL,
	[crtd_datetime] [smalldatetime] NULL,
	[crtd_prog] [varchar](8) NULL,
	[crtd_user] [varchar](10) NULL,
	[curyratetype] [varchar](6) NULL,
	[date_print_cd] [varchar](2) NULL,
	[fips_num] [varchar](10) NULL,
	[inv_attach_cd] [varchar](4) NULL,
	[inv_format_cd] [varchar](4) NULL,
	[last_bill_date] [smalldatetime] NULL,
	[lupd_datetime] [smalldatetime] NULL,
	[lupd_prog] [varchar](8) NULL,
	[lupd_user] [varchar](10) NULL,
	[noteid] [int] NULL,
	[pb_id01] [varchar](30) NULL,
	[pb_id02] [varchar](30) NULL,
	[pb_id03] [varchar](16) NULL,
	[pb_id04] [varchar](16) NULL,
	[pb_id05] [varchar](4) NULL,
	[pb_id06] [float] NULL,
	[pb_id07] [float] NULL,
	[pb_id08] [smalldatetime] NULL,
	[pb_id09] [smalldatetime] NULL,
	[pb_id10] [int] NULL,
	[pb_id11] [varchar](30) NULL,
	[pb_id12] [varchar](30) NULL,
	[pb_id13] [varchar](4) NULL,
	[pb_id14] [varchar](4) NULL,
	[pb_id15] [varchar](4) NULL,
	[pb_id16] [varchar](4) NULL,
	[pb_id17] [varchar](2) NULL,
	[pb_id18] [varchar](2) NULL,
	[pb_id19] [varchar](2) NULL,
	[pb_id20] [varchar](2) NULL,
	[project] [varchar](16) NULL,
	[project_billwith] [varchar](16) NULL,
	[retention_method] [varchar](2) NULL,
	[retention_percent] [float] NULL,
	[user1] [varchar](30) NULL,
	[user2] [varchar](30) NULL,
	[user3] [float] NULL,
	[user4] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJBILL] ADD  CONSTRAINT [DF_xAPJBILL_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
