USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLUpdates]    Script Date: 12/21/2015 14:10:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLUpdates](
	[llAction] [char](20) NOT NULL,
	[llAppname] [char](128) NOT NULL,
	[llDate] [smalldatetime] NOT NULL,
	[llHostName] [char](30) NOT NULL,
	[llLineId] [int] NOT NULL,
	[llTableDescr] [char](100) NOT NULL,
	[llTableName] [char](20) NOT NULL,
	[llText] [text] NOT NULL,
	[llUserId] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llAction]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llAppname]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('01/01/1900') FOR [llDate]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llHostName]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ((0)) FOR [llLineId]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llTableDescr]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llTableName]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llText]
GO
ALTER TABLE [dbo].[PSSLLUpdates] ADD  DEFAULT ('') FOR [llUserId]
GO
