USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJBillCh]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBillCh](
	[appnbr] [char](6) NOT NULL,
	[arch_pjt] [char](16) NOT NULL,
	[BaseCuryID] [char](4) NOT NULL,
	[bh_01] [char](30) NOT NULL,
	[bh_02] [char](30) NOT NULL,
	[bh_03] [char](16) NOT NULL,
	[bh_04] [char](16) NOT NULL,
	[bh_05] [char](4) NOT NULL,
	[bh_06] [float] NOT NULL,
	[bh_07] [float] NOT NULL,
	[bh_08] [smalldatetime] NOT NULL,
	[bh_09] [smalldatetime] NOT NULL,
	[bh_10] [int] NOT NULL,
	[bh_11] [char](30) NOT NULL,
	[bh_12] [char](30) NOT NULL,
	[bh_13] [char](16) NOT NULL,
	[bh_14] [char](16) NOT NULL,
	[bh_15] [char](4) NOT NULL,
	[bh_16] [float] NOT NULL,
	[bh_17] [float] NOT NULL,
	[bh_18] [smalldatetime] NOT NULL,
	[bh_19] [smalldatetime] NOT NULL,
	[bh_20] [int] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[date_app] [smalldatetime] NOT NULL,
	[date_from] [smalldatetime] NOT NULL,
	[date_to] [smalldatetime] NOT NULL,
	[draft_num] [char](10) NOT NULL,
	[invoice_num] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[retention_method] [char](2) NOT NULL,
	[retention_percent1] [float] NOT NULL,
	[retention_percent2] [float] NOT NULL,
	[status] [char](1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[wsid] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbillch0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[appnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
