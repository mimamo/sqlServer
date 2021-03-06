USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PJBUDSUM]    Script Date: 12/21/2015 15:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBUDSUM](
	[acct] [char](16) NOT NULL,
	[amount_01] [float] NOT NULL,
	[amount_02] [float] NOT NULL,
	[amount_03] [float] NOT NULL,
	[amount_04] [float] NOT NULL,
	[amount_05] [float] NOT NULL,
	[amount_06] [float] NOT NULL,
	[amount_07] [float] NOT NULL,
	[amount_08] [float] NOT NULL,
	[amount_09] [float] NOT NULL,
	[amount_10] [float] NOT NULL,
	[amount_11] [float] NOT NULL,
	[amount_12] [float] NOT NULL,
	[amount_13] [float] NOT NULL,
	[amount_14] [float] NOT NULL,
	[amount_15] [float] NOT NULL,
	[amount_bf] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](16) NOT NULL,
	[fsyear_num] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[planNbr] [char](2) NOT NULL,
	[project] [char](16) NOT NULL,
	[rate] [float] NOT NULL,
	[total_amount] [float] NOT NULL,
	[total_units] [float] NOT NULL,
	[units_01] [float] NOT NULL,
	[units_02] [float] NOT NULL,
	[units_03] [float] NOT NULL,
	[units_04] [float] NOT NULL,
	[units_05] [float] NOT NULL,
	[units_06] [float] NOT NULL,
	[units_07] [float] NOT NULL,
	[units_08] [float] NOT NULL,
	[units_09] [float] NOT NULL,
	[units_10] [float] NOT NULL,
	[units_11] [float] NOT NULL,
	[units_12] [float] NOT NULL,
	[units_13] [float] NOT NULL,
	[units_14] [float] NOT NULL,
	[units_15] [float] NOT NULL,
	[units_bf] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbudsum0] PRIMARY KEY CLUSTERED 
(
	[fsyear_num] ASC,
	[project] ASC,
	[pjt_entity] ASC,
	[acct] ASC,
	[planNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
