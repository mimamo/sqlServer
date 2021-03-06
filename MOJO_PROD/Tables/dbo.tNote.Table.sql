USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tNote]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tNote](
	[NoteKey] [int] IDENTITY(1,1) NOT NULL,
	[NoteGroupKey] [int] NOT NULL,
	[Subject] [varchar](300) NULL,
	[NoteField] [text] NULL,
	[DisplayOrder] [int] NULL,
	[InactiveDate] [smalldatetime] NULL,
	[DateCreated] [smalldatetime] NULL,
	[CreatedBy] [int] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[NoteOrder] [int] NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
 CONSTRAINT [PK_tNote] PRIMARY KEY NONCLUSTERED 
(
	[NoteKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
