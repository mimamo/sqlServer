USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectTypeMasterTask]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProjectTypeMasterTask](
	[ProjectTypeKey] [int] NOT NULL,
	[MasterTaskKey] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_tProjectTypeMasterTask] PRIMARY KEY CLUSTERED 
(
	[ProjectTypeKey] ASC,
	[MasterTaskKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
