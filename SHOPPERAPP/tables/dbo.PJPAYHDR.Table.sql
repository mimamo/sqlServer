USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJPAYHDR]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPAYHDR](
	[approver] [char](10) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[batnbr] [char](10) NOT NULL,
	[bill_inv_num] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[curr_net_amt] [float] NOT NULL,
	[curr_ret_amt] [float] NOT NULL,
	[curr_total_amt] [float] NOT NULL,
	[curr_units] [float] NOT NULL,
	[Curycurr_net_amt] [float] NOT NULL,
	[Curycurr_ret_amt] [float] NOT NULL,
	[Curycurr_total_amt] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[date_submitted] [smalldatetime] NOT NULL,
	[inv_paid_flag] [char](1) NOT NULL,
	[invoice_date] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[override_reason] [char](30) NOT NULL,
	[override_vendid] [char](15) NOT NULL,
	[payreq_desc] [char](60) NOT NULL,
	[payreq_type_cd] [char](4) NOT NULL,
	[payreqnbr] [char](4) NOT NULL,
	[preparer] [char](10) NOT NULL,
	[project] [char](16) NOT NULL,
	[py_id01] [char](30) NOT NULL,
	[py_id02] [char](30) NOT NULL,
	[py_id03] [char](16) NOT NULL,
	[py_id04] [char](16) NOT NULL,
	[py_id05] [char](4) NOT NULL,
	[py_id06] [float] NOT NULL,
	[py_id07] [float] NOT NULL,
	[py_id08] [smalldatetime] NOT NULL,
	[py_id09] [smalldatetime] NOT NULL,
	[py_id10] [int] NOT NULL,
	[py_id11] [char](30) NOT NULL,
	[py_id12] [char](30) NOT NULL,
	[py_id13] [char](16) NOT NULL,
	[py_id14] [char](16) NOT NULL,
	[py_id15] [char](4) NOT NULL,
	[py_id16] [float] NOT NULL,
	[py_id17] [float] NOT NULL,
	[py_id18] [smalldatetime] NOT NULL,
	[py_id19] [smalldatetime] NOT NULL,
	[py_id20] [int] NOT NULL,
	[refnbr] [char](10) NOT NULL,
	[refnbr_ret] [char](10) NOT NULL,
	[status1] [char](1) NOT NULL,
	[status2] [char](1) NOT NULL,
	[subcontract] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[vendid] [char](15) NOT NULL,
	[vendor_invref] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpayhdr0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[subcontract] ASC,
	[payreqnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
