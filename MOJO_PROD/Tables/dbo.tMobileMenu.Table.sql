USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMobileMenu]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMobileMenu](
	[MobileMenuKey] [int] NOT NULL,
	[DefaultDisplayOrder] [int] NOT NULL,
	[RightID] [varchar](50) NOT NULL,
	[Label] [varchar](50) NOT NULL,
	[DataURL] [varchar](50) NOT NULL,
	[Class] [varchar](50) NOT NULL,
	[DefaultSelection] [int] NOT NULL,
	[PageID] [varchar](50) NULL,
 CONSTRAINT [PK_tMobileMenu] PRIMARY KEY CLUSTERED 
(
	[MobileMenuKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMobileMenu] ADD  CONSTRAINT [DF_tMobileMenu_DefaultSelection]  DEFAULT ((0)) FOR [DefaultSelection]
GO
