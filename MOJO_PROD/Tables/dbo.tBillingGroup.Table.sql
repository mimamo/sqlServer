USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBillingGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBillingGroup](
	[BillingGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GLCompanyKey] [int] NULL,
	[BillingGroupCode] [varchar](200) NOT NULL,
	[Description] [varchar](200) NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tBillingGroup] PRIMARY KEY CLUSTERED 
(
	[BillingGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tBillingGroup] ADD  CONSTRAINT [DF_tBillingGroup_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tBillingGroup] ADD  CONSTRAINT [DF_tBillingGroup_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
