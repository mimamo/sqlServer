USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMobileSearch]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMobileSearch](
	[MobileSearchKey] [int] IDENTITY(1000,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[ListID] [varchar](100) NULL,
	[UserKey] [int] NULL,
	[SearchName] [varchar](1000) NOT NULL,
	[SortField] [varchar](200) NULL,
	[GroupField] [varchar](200) NULL,
	[DisplayOrder] [int] NOT NULL,
	[StdSearchKey] [int] NULL,
	[StandardSearch] [tinyint] NULL,
	[Deleted] [tinyint] NULL,
	[SortDirection] [varchar](20) NULL,
 CONSTRAINT [PK_tMobileSearch] PRIMARY KEY CLUSTERED 
(
	[MobileSearchKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMobileSearch] ADD  CONSTRAINT [DF_tMobileSearch_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[tMobileSearch] ADD  CONSTRAINT [DF_tMobileSearch_StandardSearch]  DEFAULT ((0)) FOR [StandardSearch]
GO
ALTER TABLE [dbo].[tMobileSearch] ADD  CONSTRAINT [DF_tMobileSearch_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
