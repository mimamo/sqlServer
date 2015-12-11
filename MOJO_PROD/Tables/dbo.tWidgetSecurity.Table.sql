USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWidgetSecurity]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tWidgetSecurity](
	[WidgetKey] [int] NOT NULL,
	[SecurityGroupKey] [int] NOT NULL,
	[CanView] [tinyint] NOT NULL,
	[CanEdit] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tWidgetSecurity] PRIMARY KEY CLUSTERED 
(
	[WidgetKey] ASC,
	[SecurityGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tWidgetSecurity] ADD  CONSTRAINT [DF_tWidgetSecurity_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
