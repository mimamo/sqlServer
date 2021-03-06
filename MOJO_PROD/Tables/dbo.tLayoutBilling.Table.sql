USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLayoutBilling]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLayoutBilling](
	[LayoutKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[ParentEntity] [varchar](50) NULL,
	[ParentEntityKey] [int] NULL,
	[DisplayOption] [smallint] NULL,
	[DisplayOrder] [int] NULL,
	[LayoutOrder] [int] NULL,
	[LayoutLevel] [smallint] NULL,
 CONSTRAINT [PK_tLayoutBilling] PRIMARY KEY CLUSTERED 
(
	[LayoutKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
