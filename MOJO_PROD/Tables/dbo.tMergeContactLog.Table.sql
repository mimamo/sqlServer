USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMergeContactLog]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tMergeContactLog](
	[OwnerCompanyKey] [int] NOT NULL,
	[OldUserKey] [int] NULL,
	[OldCompanyKey] [int] NOT NULL,
	[NewUserKey] [int] NULL,
	[NewCompanyKey] [int] NOT NULL,
	[MergeDate] [smalldatetime] NOT NULL,
	[MergedBy] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tMergeContactLog] ADD  CONSTRAINT [DF_tMergeContactLog_MergeDate]  DEFAULT (getdate()) FOR [MergeDate]
GO
