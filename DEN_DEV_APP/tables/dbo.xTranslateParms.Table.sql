USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xTranslateParms]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xTranslateParms](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ReportID] [varchar](25) NOT NULL,
	[InputFieldName] [varchar](255) NOT NULL,
	[OutputFieldName] [varchar](255) NOT NULL,
 CONSTRAINT [xPK_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY],
 CONSTRAINT [xIX_ReportIDInputFieldName] UNIQUE NONCLUSTERED 
(
	[ReportID] ASC,
	[InputFieldName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
