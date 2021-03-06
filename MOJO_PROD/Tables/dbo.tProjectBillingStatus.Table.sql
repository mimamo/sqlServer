USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectBillingStatus]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectBillingStatus](
	[ProjectBillingStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ProjectBillingStatusID] [varchar](30) NOT NULL,
	[ProjectBillingStatus] [varchar](200) NOT NULL,
	[DisplayOrder] [int] NULL,
	[Active] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tProjectBillingStatus] PRIMARY KEY NONCLUSTERED 
(
	[ProjectBillingStatusKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectBillingStatus] ADD  CONSTRAINT [DF_tProjectBillingStatus_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
