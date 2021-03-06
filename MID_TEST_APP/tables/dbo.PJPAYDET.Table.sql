USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPAYDET]    Script Date: 12/21/2015 14:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPAYDET](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[curr_net_amt] [float] NOT NULL,
	[curr_rate] [float] NOT NULL,
	[curr_ret_amt] [float] NOT NULL,
	[curr_total_amt] [float] NOT NULL,
	[curr_units] [float] NOT NULL,
	[Curycurr_net_amt] [float] NOT NULL,
	[Curycurr_ret_amt] [float] NOT NULL,
	[Curycurr_total_amt] [float] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[payreqnbr] [char](4) NOT NULL,
	[pd_id01] [char](30) NOT NULL,
	[pd_id02] [char](30) NOT NULL,
	[pd_id03] [char](16) NOT NULL,
	[pd_id04] [char](16) NOT NULL,
	[pd_id05] [char](4) NOT NULL,
	[pd_id06] [float] NOT NULL,
	[pd_id07] [float] NOT NULL,
	[pd_id08] [smalldatetime] NOT NULL,
	[pd_id09] [smalldatetime] NOT NULL,
	[pd_id10] [int] NOT NULL,
	[pd_id11] [char](30) NOT NULL,
	[pd_id12] [char](30) NOT NULL,
	[pd_id13] [char](16) NOT NULL,
	[pd_id14] [char](16) NOT NULL,
	[pd_id15] [char](4) NOT NULL,
	[pd_id16] [float] NOT NULL,
	[pd_id17] [float] NOT NULL,
	[pd_id18] [smalldatetime] NOT NULL,
	[pd_id19] [smalldatetime] NOT NULL,
	[pd_id20] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[request_percent] [float] NOT NULL,
	[status1] [char](1) NOT NULL,
	[sub_line_item] [char](4) NOT NULL,
	[subcontract] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpaydet0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[subcontract] ASC,
	[payreqnbr] ASC,
	[sub_line_item] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
