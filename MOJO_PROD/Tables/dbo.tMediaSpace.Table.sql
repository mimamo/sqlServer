USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaSpace]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaSpace](
	[MediaSpaceKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[SpaceID] [varchar](50) NOT NULL,
	[SpaceName] [varchar](500) NOT NULL,
	[SpaceShortName] [varchar](100) NULL,
	[MediaUnitTypeKey] [int] NULL,
	[Qty1] [decimal](24, 4) NULL,
	[Qty2] [decimal](24, 4) NULL,
	[Active] [tinyint] NULL,
	[POKind] [smallint] NULL,
	[ItemKey] [int] NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_tMediaSpace] PRIMARY KEY CLUSTERED 
(
	[MediaSpaceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
