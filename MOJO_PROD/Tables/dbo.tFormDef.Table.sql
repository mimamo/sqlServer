USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFormDef]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFormDef](
	[FormDefKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[FormName] [varchar](100) NOT NULL,
	[FormPrefix] [varchar](10) NOT NULL,
	[Description] [varchar](500) NULL,
	[WorkingLevel] [smallint] NOT NULL,
	[FormType] [smallint] NOT NULL,
	[Active] [tinyint] NOT NULL,
	[OnlyAuthorCanClose] [tinyint] NOT NULL,
	[OnlyAuthorEditDate] [tinyint] NOT NULL,
	[OnlyAuthOrAssignCanEdit] [tinyint] NOT NULL,
	[NotifyAssignee] [tinyint] NOT NULL,
	[NotifyAuthorOnClose] [tinyint] NOT NULL,
	[NotifyAuthorOnUpdate] [tinyint] NOT NULL,
	[OnlyAuthorEdit] [tinyint] NULL,
	[DisplayColor] [varchar](20) NULL,
	[UniqueNumbers] [tinyint] NULL,
 CONSTRAINT [PK_tFormDef] PRIMARY KEY NONCLUSTERED 
(
	[FormDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_WorkingLevel]  DEFAULT ((1)) FOR [WorkingLevel]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_FormType]  DEFAULT ((1)) FOR [FormType]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_AuthorCanClose]  DEFAULT ((1)) FOR [OnlyAuthorCanClose]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_OnlyAuthorEditDate]  DEFAULT ((1)) FOR [OnlyAuthorEditDate]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_OnlyAuthOrAssignCanEdit]  DEFAULT ((1)) FOR [OnlyAuthOrAssignCanEdit]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_NotifyAssignee]  DEFAULT ((1)) FOR [NotifyAssignee]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_NotifyAuthorOnClose]  DEFAULT ((1)) FOR [NotifyAuthorOnClose]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_NotifyAuthorOnUpdate]  DEFAULT ((1)) FOR [NotifyAuthorOnUpdate]
GO
ALTER TABLE [dbo].[tFormDef] ADD  CONSTRAINT [DF_tFormDef_OnlyAuthorEdit]  DEFAULT ((0)) FOR [OnlyAuthorEdit]
GO
