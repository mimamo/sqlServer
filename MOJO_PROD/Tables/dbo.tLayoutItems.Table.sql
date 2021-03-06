USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLayoutItems]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLayoutItems](
	[LayoutReportKey] [int] NOT NULL,
	[ElementID] [smallint] NOT NULL,
	[ParentID] [smallint] NOT NULL,
	[ReportTag] [varchar](50) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[BackColor] [int] NULL,
	[BorderColor] [int] NULL,
	[BorderStyle] [varchar](50) NULL,
	[BorderLeft] [tinyint] NULL,
	[BorderRight] [tinyint] NULL,
	[BorderTop] [tinyint] NULL,
	[BorderBottom] [tinyint] NULL,
	[BorderThickness] [smallint] NULL,
	[Shadow] [tinyint] NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[Height] [int] NULL,
	[Width] [int] NULL,
	[Text] [text] NULL,
	[FontFamily] [varchar](50) NULL,
	[FontSize] [smallint] NULL,
	[FontItalic] [tinyint] NULL,
	[FontBold] [tinyint] NULL,
	[FontUnderline] [tinyint] NULL,
	[TextAlign] [varchar](50) NULL,
	[LineColor] [int] NULL,
	[LineStyle] [varchar](50) NULL,
	[LineWeight] [tinyint] NULL,
	[X1] [int] NULL,
	[Y1] [int] NULL,
	[X2] [int] NULL,
	[Y2] [int] NULL,
	[CornerRadius] [smallint] NULL,
	[ShapeType] [varchar](50) NULL,
	[ImageAlignment] [varchar](50) NULL,
	[ImageMode] [varchar](50) NULL,
	[ConfigData] [text] NULL,
	[DataField] [varchar](200) NULL,
	[ForeColor] [int] NULL,
	[ImageData] [image] NULL,
	[CanGrow] [tinyint] NULL,
	[CanShrink] [tinyint] NULL,
	[WordWrap] [tinyint] NULL,
	[DataType] [varchar](50) NULL,
	[DecimalPlaces] [smallint] NULL,
	[ShowCurrencySymbol] [tinyint] NULL,
 CONSTRAINT [PK_tLayoutItems] PRIMARY KEY CLUSTERED 
(
	[LayoutReportKey] ASC,
	[ElementID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
