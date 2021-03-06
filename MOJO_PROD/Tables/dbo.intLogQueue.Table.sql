USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[intLogQueue]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[intLogQueue](
	[LogKey] [int] IDENTITY(1,1) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NULL,
	[EntityUID] [uniqueidentifier] NULL,
	[Action] [varchar](20) NULL,
	[DateAdded] [smalldatetime] NOT NULL,
	[DateTransferred] [smalldatetime] NULL,
	[Error] [text] NULL,
	[TransferStatus] [varchar](50) NULL,
 CONSTRAINT [PK_intLogQueue] PRIMARY KEY CLUSTERED 
(
	[LogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[intLogQueue] ADD  CONSTRAINT [DF_intLogQueue_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
