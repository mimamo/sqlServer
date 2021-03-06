USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWidgetCompany]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWidgetCompany](
	[WidgetKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Settings] [varchar](4000) NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tWidgetCompany] PRIMARY KEY CLUSTERED 
(
	[WidgetKey] ASC,
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWidgetCompany] ADD  CONSTRAINT [DF_tWidgetCompany_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
