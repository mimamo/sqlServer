USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpAPSXfer]    Script Date: 12/21/2015 14:26:46 ******/
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
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_act_amount]  DEFAULT ((0.0)) FOR [act_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_bill_amount]  DEFAULT ((0.0)) FOR [bill_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_btd_amount]  DEFAULT ((0.0)) FOR [btd_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_cor_amount]  DEFAULT ((0)) FOR [cos_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_crtd_prog]  DEFAULT (' ') FOR [crtd_prog]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_crtd_user]  DEFAULT (' ') FOR [crtd_user]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_eac_amount]  DEFAULT ((0.0)) FOR [est_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_studio_entDesc]  DEFAULT (' ') FOR [Studio_entityDesc]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_recover_amount]  DEFAULT ((0)) FOR [recover_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_rem_amount]  DEFAULT ((0.0)) FOR [rem_amount]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_user1]  DEFAULT (' ') FOR [user1]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_user2]  DEFAULT (' ') FOR [user2]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_user3]  DEFAULT ((0.0)) FOR [user3]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_user4]  DEFAULT ((0.0)) FOR [user4]
GO
ALTER TABLE [dbo].[xtmpAPSXfer] ADD  CONSTRAINT [DF_xtmpAPSXfer_var_amount]  DEFAULT ((0.0)) FOR [var_amount]
GO
