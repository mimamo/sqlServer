USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAppMenu]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAppMenu](
	[AppMenuKey] [int] IDENTITY(10000,1) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ActionID] [varchar](100) NULL,
	[DisplayOrder] [int] NULL,
	[FolderKey] [int] NULL,
	[Label] [varchar](200) NULL,
	[Icon] [varchar](50) NULL,
	[NewActionID] [varchar](100) NULL,
	[RightID] [varchar](100) NULL,
	[NewRightID] [varchar](100) NULL,
 CONSTRAINT [PK_tAppMenu] PRIMARY KEY CLUSTERED 
(
	[AppMenuKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
