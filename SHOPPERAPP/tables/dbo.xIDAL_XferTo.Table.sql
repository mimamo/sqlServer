USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xIDAL_XferTo]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xIDAL_XferTo](
	[pjt_entity] [char](32) NOT NULL,
	[entityDesc] [char](30) NOT NULL,
	[project] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[From_Project] [char](16) NOT NULL,
	[xfer_amount] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xIDAL_XferTo0] PRIMARY KEY CLUSTERED 
(
	[From_Project] ASC,
	[project] ASC,
	[pjt_entity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xIDAL_XferTo] ADD  CONSTRAINT [DF_xIDAL_XferTo_agency_entDesc]  DEFAULT (' ') FOR [entityDesc]
GO
ALTER TABLE [dbo].[xIDAL_XferTo] ADD  CONSTRAINT [DF_xIDAL_XferTo_crtd_prog]  DEFAULT (' ') FOR [crtd_prog]
GO
ALTER TABLE [dbo].[xIDAL_XferTo] ADD  CONSTRAINT [DF_xIDAL_XferTo_crtd_user]  DEFAULT (' ') FOR [crtd_user]
GO
ALTER TABLE [dbo].[xIDAL_XferTo] ADD  CONSTRAINT [DF_xIDAL_XferTo_xfer_amount]  DEFAULT ((0.0)) FOR [xfer_amount]
GO
