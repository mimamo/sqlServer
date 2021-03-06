USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xJATemplateDtl_IWT]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJATemplateDtl_IWT](
	[TemplateDtlKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FieldFilter] [varchar](50) NOT NULL,
	[FieldKey] [int] NOT NULL,
	[TemplateHdrKey] [int] NOT NULL,
	[Value] [varchar](255) NOT NULL,
	[Value2] [varchar](255) NULL,
 CONSTRAINT [PK_xJATemplateDtl_IWT] PRIMARY KEY CLUSTERED 
(
	[TemplateDtlKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
