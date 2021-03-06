USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDistributionGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDistributionGroup](
	[DistributionGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NULL,
	[Personal] [tinyint] NOT NULL,
	[GroupName] [varchar](200) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tDistributionGroup] PRIMARY KEY CLUSTERED 
(
	[DistributionGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDistributionGroup] ADD  CONSTRAINT [DF_tDistributionGroup_Personal]  DEFAULT ((0)) FOR [Personal]
GO
ALTER TABLE [dbo].[tDistributionGroup] ADD  CONSTRAINT [DF_tDistributionGroup_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tDistributionGroup] ADD  CONSTRAINT [DF_tDistributionGroup_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
