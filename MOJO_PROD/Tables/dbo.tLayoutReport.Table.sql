USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLayoutReport]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLayoutReport](
	[LayoutReportKey] [int] IDENTITY(1,1) NOT NULL,
	[LayoutKey] [int] NULL,
	[Entity] [varchar](50) NULL,
	[PaperType] [varchar](50) NULL,
	[PaperWidth] [smallint] NULL,
	[PaperHeight] [smallint] NULL,
	[PaperOrientation] [varchar](50) NULL,
	[MarginTop] [smallint] NULL,
	[MarginBottom] [smallint] NULL,
	[MarginLeft] [smallint] NULL,
	[MarginRight] [smallint] NULL,
	[Watermark] [image] NULL,
	[WatermarkSizeMode] [varchar](50) NULL,
	[WatermarkAlignment] [varchar](50) NULL,
 CONSTRAINT [PK_tLayoutReport] PRIMARY KEY CLUSTERED 
(
	[LayoutReportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
