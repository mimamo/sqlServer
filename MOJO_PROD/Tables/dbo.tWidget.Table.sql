USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWidget]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWidget](
	[WidgetKey] [int] NOT NULL,
	[CompanyKey] [int] NULL,
	[DisplayName] [varchar](200) NOT NULL,
	[Description] [varchar](2000) NULL,
	[WidgetType] [varchar](50) NOT NULL,
	[WidgetGroup] [int] NOT NULL,
	[SourceFile] [varchar](300) NOT NULL,
	[Icon] [varchar](100) NOT NULL,
	[Settings] [varchar](4000) NULL,
	[UserEdit] [tinyint] NOT NULL,
	[HasSettings] [tinyint] NOT NULL,
	[Height] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[CanResize] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tWidget] PRIMARY KEY CLUSTERED 
(
	[WidgetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWidget] ADD  CONSTRAINT [DF_tWidget_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
