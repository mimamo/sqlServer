USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xATABLES]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xATABLES](
	[Module] [char](4) NOT NULL,
	[TableDescr] [char](40) NOT NULL,
	[TableName] [char](20) NOT NULL,
	[AddTable] [char](1) NOT NULL,
	[RemoveTable] [char](1) NOT NULL,
	[AuditTable] [char](1) NOT NULL,
	[InitialData] [char](1) NOT NULL,
	[IndexName] [char](50) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xATABLES0] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_Module]  DEFAULT (' ') FOR [Module]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_TableDescr]  DEFAULT (' ') FOR [TableDescr]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_TableName]  DEFAULT (' ') FOR [TableName]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_AddTable]  DEFAULT ('F') FOR [AddTable]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_RemoveTable]  DEFAULT ('F') FOR [RemoveTable]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_AuditTable]  DEFAULT ('F') FOR [AuditTable]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_InitialData]  DEFAULT ('F') FOR [InitialData]
GO
ALTER TABLE [dbo].[xATABLES] ADD  CONSTRAINT [DF_xATABLES_IndexName]  DEFAULT (' ') FOR [IndexName]
GO
