USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMobileSearchDefault]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMobileSearchDefault](
	[ListID] [varchar](100) NOT NULL,
	[UserKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[MobileSearchKey] [int] NOT NULL,
 CONSTRAINT [PK_tMobileSearchDefault] PRIMARY KEY CLUSTERED 
(
	[ListID] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
