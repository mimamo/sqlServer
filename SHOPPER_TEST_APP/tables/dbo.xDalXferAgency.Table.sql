USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xDalXferAgency]    Script Date: 12/21/2015 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xDalXferAgency](
	[agency_pjt_entity] [char](32) NOT NULL,
	[agency_entityDesc] [char](30) NOT NULL,
	[agency_project] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[discount_amount] [float] NOT NULL,
	[salesTax_amount] [float] NOT NULL,
	[studio_Project] [char](16) NOT NULL,
	[totalXfer_amount] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[valueAdd_amount] [float] NOT NULL,
	[xfer_amount] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xDalXferAgency0] PRIMARY KEY CLUSTERED 
(
	[studio_Project] ASC,
	[agency_project] ASC,
	[agency_pjt_entity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_agency_entDesc]  DEFAULT (' ') FOR [agency_entityDesc]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_crtd_prog]  DEFAULT (' ') FOR [crtd_prog]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_crtd_user]  DEFAULT (' ') FOR [crtd_user]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_discount_amount]  DEFAULT ((0.0)) FOR [discount_amount]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_salestax_amount]  DEFAULT ((0.0)) FOR [salesTax_amount]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_totalxfer_amount]  DEFAULT ((0.0)) FOR [totalXfer_amount]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_user1]  DEFAULT (' ') FOR [user1]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_user2]  DEFAULT (' ') FOR [user2]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_user3]  DEFAULT ((0.0)) FOR [user3]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_user4]  DEFAULT ((0.0)) FOR [user4]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_valueadd_amount]  DEFAULT ((0.0)) FOR [valueAdd_amount]
GO
ALTER TABLE [dbo].[xDalXferAgency] ADD  CONSTRAINT [DF_xDalXferAgency_xfer_amount]  DEFAULT ((0.0)) FOR [xfer_amount]
GO
