USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tString]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tString](
	[StringID] [varchar](50) NOT NULL,
	[StringGroupKey] [int] NOT NULL,
	[DisplayName] [varchar](500) NULL,
	[StringSingular] [varchar](500) NULL,
	[StringPlural] [varchar](500) NULL,
	[DisplayOrder] [int] NULL,
	[AllowDD] [tinyint] NULL,
	[DefaultDD] [varchar](4000) NULL,
 CONSTRAINT [PK_tString] PRIMARY KEY NONCLUSTERED 
(
	[StringID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tString]  WITH CHECK ADD  CONSTRAINT [FK_tString_tStringGroup] FOREIGN KEY([StringGroupKey])
REFERENCES [dbo].[tStringGroup] ([StringGroupKey])
GO
ALTER TABLE [dbo].[tString] CHECK CONSTRAINT [FK_tString_tStringGroup]
GO
