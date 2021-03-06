USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xCog_SEAEList]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCog_SEAEList](
	[EListItemName] [nvarchar](60) NOT NULL,
	[EListItemParentName] [nvarchar](60) NULL,
	[EListItemOrder] [float] NULL,
	[EListItemViewDepth] [float] NULL,
 CONSTRAINT [PK_xCogSEAEList] PRIMARY KEY CLUSTERED 
(
	[EListItemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
