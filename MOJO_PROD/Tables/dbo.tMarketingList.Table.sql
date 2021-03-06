USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMarketingList]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMarketingList](
	[MarketingListKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ListName] [varchar](500) NOT NULL,
	[ListID] [varchar](50) NULL,
	[LastModified] [smalldatetime] NULL,
	[ColumnDef] [text] NULL,
	[ExternalMarketingKey] [int] NULL,
 CONSTRAINT [PK_tMarketingList] PRIMARY KEY CLUSTERED 
(
	[MarketingListKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMarketingList] ADD  CONSTRAINT [DF_tMarketingList_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
