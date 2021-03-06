USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJBILLCN]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBILLCN](
	[acct] [char](16) NOT NULL,
	[amt_data] [float] NOT NULL,
	[amt_matl] [float] NOT NULL,
	[amt_prev] [float] NOT NULL,
	[amt_ret] [float] NOT NULL,
	[amt_ret_prev] [float] NOT NULL,
	[amt_sched_value] [float] NOT NULL,
	[amt_work] [float] NOT NULL,
	[appnbr] [char](6) NOT NULL,
	[bn_01] [char](30) NOT NULL,
	[bn_02] [char](30) NOT NULL,
	[bn_03] [char](16) NOT NULL,
	[bn_04] [char](16) NOT NULL,
	[bn_05] [char](4) NOT NULL,
	[bn_06] [float] NOT NULL,
	[bn_07] [float] NOT NULL,
	[bn_08] [smalldatetime] NOT NULL,
	[bn_09] [smalldatetime] NOT NULL,
	[bn_10] [int] NOT NULL,
	[bn_11] [char](30) NOT NULL,
	[bn_12] [char](30) NOT NULL,
	[bn_13] [char](16) NOT NULL,
	[bn_14] [char](16) NOT NULL,
	[bn_15] [char](4) NOT NULL,
	[bn_16] [float] NOT NULL,
	[bn_17] [float] NOT NULL,
	[bn_18] [smalldatetime] NOT NULL,
	[bn_19] [smalldatetime] NOT NULL,
	[bn_20] [int] NOT NULL,
	[change_order_num] [char](16) NOT NULL,
	[co_approval_date] [smalldatetime] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryAmt_Data] [float] NOT NULL,
	[CuryAmt_Matl] [float] NOT NULL,
	[CuryAmt_Prev] [float] NOT NULL,
	[CuryAmt_Ret] [float] NOT NULL,
	[CuryAmt_Ret_Prev] [float] NOT NULL,
	[CuryAmt_Sched_Value] [float] NOT NULL,
	[CuryAmt_Work] [float] NOT NULL,
	[desc_work] [char](40) NOT NULL,
	[itemnbr] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[percent_comp] [float] NOT NULL,
	[project] [char](16) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[retention_method] [char](2) NOT NULL,
	[retention_percent1] [float] NOT NULL,
	[retention_percent2] [float] NOT NULL,
	[status_co] [char](1) NOT NULL,
	[subtotal_flag] [char](2) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbillcn0] PRIMARY KEY NONCLUSTERED 
(
	[project] ASC,
	[appnbr] ASC,
	[itemnbr] ASC,
	[change_order_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
