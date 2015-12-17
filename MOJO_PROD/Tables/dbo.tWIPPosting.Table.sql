USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWIPPosting]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWIPPosting](
	[WIPPostingKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[PostingDate] [smalldatetime] NOT NULL,
	[SelectThroughDate] [smalldatetime] NULL,
	[Comment] [varchar](300) NULL,
	[GLCompanyKey] [int] NULL,
	[OpeningTransaction] [tinyint] NULL,
 CONSTRAINT [PK_tWIPPosting] PRIMARY KEY CLUSTERED 
(
	[WIPPostingKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWIPPosting] ADD  CONSTRAINT [DF_tWIPPosting_OpeningTransaction]  DEFAULT ((0)) FOR [OpeningTransaction]
GO
