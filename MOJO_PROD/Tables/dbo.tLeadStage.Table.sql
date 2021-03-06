USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLeadStage]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLeadStage](
	[LeadStageKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LeadStageName] [varchar](200) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[DefaultProbability] [int] NULL,
	[DisplayOnDashboard] [tinyint] NOT NULL,
	[UseDefaultProbability] [tinyint] NULL,
 CONSTRAINT [PK_tLeadStage] PRIMARY KEY NONCLUSTERED 
(
	[LeadStageKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tLeadStage] ADD  CONSTRAINT [DF_tLeadStage_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tLeadStage] ADD  CONSTRAINT [DF_tLeadStage_DisplayOnDashboard]  DEFAULT ((1)) FOR [DisplayOnDashboard]
GO
ALTER TABLE [dbo].[tLeadStage] ADD  CONSTRAINT [DF_tLeadStage_UseDefaultProbability]  DEFAULT ((0)) FOR [UseDefaultProbability]
GO
