USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFormDefSecurityGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tFormDefSecurityGroup](
	[FormDefKey] [int] NOT NULL,
	[SecurityGroupKey] [int] NOT NULL,
 CONSTRAINT [PK_tFormDefSecurityGroup] PRIMARY KEY NONCLUSTERED 
(
	[FormDefKey] ASC,
	[SecurityGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
