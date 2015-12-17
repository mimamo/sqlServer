USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectTypeService]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProjectTypeService](
	[ProjectTypeKey] [int] NOT NULL,
	[ServiceKey] [int] NOT NULL,
 CONSTRAINT [PK_tProjectTypeService] PRIMARY KEY CLUSTERED 
(
	[ProjectTypeKey] ASC,
	[ServiceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
