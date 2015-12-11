USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLayoutSection]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLayoutSection](
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
	[CanGrow] [tinyint] NOT NULL,
	[CanShrink] [tinyint] NOT NULL,
 CONSTRAINT [PK_tLayoutSection] PRIMARY KEY CLUSTERED 
(
	[LayoutReportKey] ASC,
	[ElementID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
