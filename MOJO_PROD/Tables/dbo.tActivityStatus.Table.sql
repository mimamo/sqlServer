USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActivityStatus]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tActivityStatus](
	[ActivityStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NULL,
	[StatusName] [varchar](500) NOT NULL,
	[AssignToKey] [int] NULL,
	[IsCompleted] [tinyint] NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_tActivityStatus] PRIMARY KEY CLUSTERED 
(
	[ActivityStatusKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
