USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRightAssigned]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRightAssigned](
	[RightAssignedKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [varchar](35) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[RightKey] [int] NOT NULL,
 CONSTRAINT [tRightAssigned_PK] PRIMARY KEY CLUSTERED 
(
	[RightAssignedKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
