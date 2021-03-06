USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xAlt_ProjectDefaultBill]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAlt_ProjectDefaultBill](
	[approval_sw] [char](1) NOT NULL,
	[approver] [char](10) NOT NULL,
	[BillCuryId] [char](4) NOT NULL,
	[biller] [char](10) NOT NULL,
	[billings_cycle_cd] [char](2) NOT NULL,
	[billings_level] [char](2) NOT NULL,
	[bill_type_cd] [char](4) NOT NULL,
	[copy_num] [smallint] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[curyratetype] [char](6) NOT NULL,
	[date_print_cd] [char](2) NOT NULL,
	[DefaultType] [char](30) NOT NULL,
	[fips_num] [char](10) NOT NULL,
	[inv_attach_cd] [char](2) NOT NULL,
	[inv_format_cd] [char](2) NOT NULL,
	[last_bill_date] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pb_id01] [char](30) NOT NULL,
	[pb_id02] [char](30) NOT NULL,
	[pb_id03] [char](16) NOT NULL,
	[pb_id04] [char](16) NOT NULL,
	[pb_id05] [char](4) NOT NULL,
	[pb_id06] [float] NOT NULL,
	[pb_id07] [float] NOT NULL,
	[pb_id08] [smalldatetime] NOT NULL,
	[pb_id09] [smalldatetime] NOT NULL,
	[pb_id10] [int] NOT NULL,
	[pb_id11] [char](30) NOT NULL,
	[pb_id12] [char](30) NOT NULL,
	[pb_id13] [char](4) NOT NULL,
	[pb_id14] [char](4) NOT NULL,
	[pb_id15] [char](4) NOT NULL,
	[pb_id16] [char](4) NOT NULL,
	[pb_id17] [char](2) NOT NULL,
	[pb_id18] [char](2) NOT NULL,
	[pb_id19] [char](2) NOT NULL,
	[pb_id20] [char](2) NOT NULL,
	[project_billwith] [char](16) NOT NULL,
	[retention_method] [char](2) NOT NULL,
	[retention_percent] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xAlt_ProjectDefaultBill0] PRIMARY KEY CLUSTERED 
(
	[DefaultType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
