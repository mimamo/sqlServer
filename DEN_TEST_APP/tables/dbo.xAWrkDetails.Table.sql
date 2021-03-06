USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xAWrkDetails]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAWrkDetails](
	[FieldName] [char](50) NOT NULL,
	[FieldValueBefore] [char](50) NULL,
	[FieldValueAfter] [char](50) NULL,
	[GuID] [char](32) NOT NULL,
	[Changed] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xAWrkDetails0] PRIMARY KEY CLUSTERED 
(
	[FieldName] ASC,
	[GuID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAWrkDetails] ADD  CONSTRAINT [DF_xAWrkDetails_FieldName]  DEFAULT (' ') FOR [FieldName]
GO
ALTER TABLE [dbo].[xAWrkDetails] ADD  CONSTRAINT [DF_xAWrkDetails_FieldValueBefore]  DEFAULT (' ') FOR [FieldValueBefore]
GO
ALTER TABLE [dbo].[xAWrkDetails] ADD  CONSTRAINT [DF_xAWrkDetails_FieldValueAfter]  DEFAULT (' ') FOR [FieldValueAfter]
GO
ALTER TABLE [dbo].[xAWrkDetails] ADD  CONSTRAINT [DF_xAWrkDetails_GuID]  DEFAULT (' ') FOR [GuID]
GO
ALTER TABLE [dbo].[xAWrkDetails] ADD  CONSTRAINT [DF_xAWrkDetails_Changed]  DEFAULT ('N') FOR [Changed]
GO
