USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaPosition]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaPosition](
	[MediaPositionKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[PositionID] [varchar](50) NOT NULL,
	[PositionName] [varchar](500) NOT NULL,
	[PositionShortName] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[DisplayOrder] [int] NULL,
	[Active] [tinyint] NULL,
	[POKind] [smallint] NULL,
	[ItemKey] [int] NULL,
 CONSTRAINT [PK_tMediaPosition] PRIMARY KEY CLUSTERED 
(
	[MediaPositionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaPosition] ADD  CONSTRAINT [DF_tMediatPosition_DisplayOrder]  DEFAULT ((1)) FOR [DisplayOrder]
GO
