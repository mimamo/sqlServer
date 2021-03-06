USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xJAFilterDefinitions_IWT]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJAFilterDefinitions_IWT](
	[FieldKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FieldName] [varchar](100) NOT NULL,
	[FieldDisplayName] [varchar](100) NOT NULL,
	[FieldType] [char](1) NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[SortOrder] [smallint] NOT NULL,
 CONSTRAINT [PK_xJAFilterDefinitions_IWT] PRIMARY KEY CLUSTERED 
(
	[FieldKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
