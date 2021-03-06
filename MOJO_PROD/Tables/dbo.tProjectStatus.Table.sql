USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectStatus]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectStatus](
	[ProjectStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ProjectStatusID] [varchar](30) NOT NULL,
	[ProjectStatus] [varchar](200) NULL,
	[DisplayOrder] [int] NOT NULL,
	[StatusCategory] [smallint] NULL,
	[TimeActive] [tinyint] NOT NULL,
	[ExpenseActive] [tinyint] NOT NULL,
	[IsActive] [tinyint] NOT NULL,
	[Locked] [tinyint] NULL,
	[OnHold] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[IncludeInForecast] [tinyint] NOT NULL,
 CONSTRAINT [PK_tProjectStatus] PRIMARY KEY NONCLUSTERED 
(
	[ProjectStatusKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_DisplayOrder]  DEFAULT ((1)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_StatusCategory]  DEFAULT ((1)) FOR [StatusCategory]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_TimeActive]  DEFAULT ((1)) FOR [TimeActive]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_ExpenseActive]  DEFAULT ((1)) FOR [ExpenseActive]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tProjectStatus] ADD  CONSTRAINT [DF_tProjectStatus_IncludeInForecast]  DEFAULT ((0)) FOR [IncludeInForecast]
GO
