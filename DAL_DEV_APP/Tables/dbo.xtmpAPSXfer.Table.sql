USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpAPSXfer]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpAPSXfer](
	[act_amount] [float] NOT NULL,
	[bill_amount] [float] NOT NULL,
	[btd_amount] [float] NOT NULL,
	[cos_amount] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[est_amount] [float] NOT NULL,
	[Studio_pjt_entity] [char](32) NOT NULL,
	[Studio_entityDesc] [char](30) NOT NULL,
	[Studio_project] [char](16) NOT NULL,
	[recover_amount] [float] NOT NULL,
	[rem_amount] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[var_amount] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xtmpAPSXfer0] PRIMARY KEY CLUSTERED 
(
	[Studio_project] ASC,
	[Studio_pjt_entity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
