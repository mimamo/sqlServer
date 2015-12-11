USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRequestDefSpec]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRequestDefSpec](
	[RequestDefSpecKey] [int] IDENTITY(1,1) NOT NULL,
	[RequestDefKey] [int] NOT NULL,
	[FieldSetKey] [int] NOT NULL,
	[Subject] [varchar](200) NOT NULL,
	[Description] [varchar](500) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_tRequestDefSpec] PRIMARY KEY CLUSTERED 
(
	[RequestDefSpecKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tRequestDefSpec]  WITH NOCHECK ADD  CONSTRAINT [FK_tRequestDefSpec_tRequestDef] FOREIGN KEY([RequestDefKey])
REFERENCES [dbo].[tRequestDef] ([RequestDefKey])
GO
ALTER TABLE [dbo].[tRequestDefSpec] CHECK CONSTRAINT [FK_tRequestDefSpec_tRequestDef]
GO
