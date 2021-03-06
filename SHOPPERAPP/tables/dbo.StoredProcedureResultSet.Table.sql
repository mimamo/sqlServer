USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[StoredProcedureResultSet]    Script Date: 12/21/2015 16:12:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StoredProcedureResultSet](
	[ID] [uniqueidentifier] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
	[Body] [varchar](8000) NULL,
 CONSTRAINT [PK_StoredProcedureResultSet] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[SequenceNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
