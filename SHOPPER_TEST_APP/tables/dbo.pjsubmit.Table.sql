USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[pjsubmit]    Script Date: 12/21/2015 16:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pjsubmit](
	[alert_type] [char](2) NOT NULL,
	[category] [char](1) NOT NULL,
	[change_order_num] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[date_alert] [smalldatetime] NOT NULL,
	[date_create] [smalldatetime] NOT NULL,
	[date_due] [smalldatetime] NOT NULL,
	[date_received] [smalldatetime] NOT NULL,
	[due_from] [char](30) NOT NULL,
	[employee] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pay_control] [char](2) NOT NULL,
	[project] [char](16) NOT NULL,
	[received_from] [char](30) NOT NULL,
	[response_comment] [char](50) NOT NULL,
	[sm_id01] [char](30) NOT NULL,
	[sm_id02] [char](30) NOT NULL,
	[sm_id03] [char](16) NOT NULL,
	[sm_id04] [char](16) NOT NULL,
	[sm_id05] [char](4) NOT NULL,
	[sm_id06] [float] NOT NULL,
	[sm_id07] [float] NOT NULL,
	[sm_id08] [smalldatetime] NOT NULL,
	[sm_id09] [smalldatetime] NOT NULL,
	[sm_id10] [int] NOT NULL,
	[sm_id11] [char](30) NOT NULL,
	[sm_id12] [char](30) NOT NULL,
	[sm_id13] [char](16) NOT NULL,
	[sm_id14] [char](16) NOT NULL,
	[sm_id15] [char](4) NOT NULL,
	[sm_id16] [float] NOT NULL,
	[sm_id17] [float] NOT NULL,
	[sm_id18] [smalldatetime] NOT NULL,
	[sm_id19] [smalldatetime] NOT NULL,
	[sm_id20] [int] NOT NULL,
	[status1] [char](1) NOT NULL,
	[status2] [char](1) NOT NULL,
	[subcontract] [char](16) NOT NULL,
	[submit_desc] [char](60) NOT NULL,
	[submit_type_cd] [char](4) NOT NULL,
	[submitnbr] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjsubmit0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[subcontract] ASC,
	[submitnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
