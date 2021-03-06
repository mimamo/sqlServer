USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCBPosting]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCBPosting](
	[CBPostingKey] [int] IDENTITY(1,1) NOT NULL,
	[CBBatchKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[CBCodeKey] [int] NULL,
	[GLAccountKey] [int] NULL,
	[Debit] [money] NOT NULL,
	[Credit] [money] NOT NULL,
	[Validated] [tinyint] NULL,
	[ErrorMessage] [varchar](500) NULL,
	[ErrorMessageCode] [varchar](250) NULL,
 CONSTRAINT [PK_tCBPosting] PRIMARY KEY CLUSTERED 
(
	[CBPostingKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCBPosting] ADD  CONSTRAINT [DF_tCBPosting_Validated]  DEFAULT ((1)) FOR [Validated]
GO
