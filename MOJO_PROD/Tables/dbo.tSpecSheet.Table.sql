USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSpecSheet]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSpecSheet](
	[SpecSheetKey] [int] IDENTITY(1,1) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[FieldSetKey] [int] NOT NULL,
	[CustomFieldKey] [int] NOT NULL,
	[Subject] [varchar](200) NOT NULL,
	[Description] [text] NULL,
	[DisplayOrder] [int] NULL,
	[CreatedByKey] [int] NULL,
	[CreatedByDate] [datetime] NULL,
	[UpdatedByKey] [int] NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_tSpecSheet] PRIMARY KEY CLUSTERED 
(
	[SpecSheetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
