USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAttachmentBackup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAttachmentBackup](
	[AttachmentKey] [int] NOT NULL,
	[AssociatedEntity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[AddedBy] [int] NOT NULL,
	[FileName] [varchar](300) NOT NULL,
	[Comments] [varchar](1000) NULL,
	[Path] [varchar](2000) NULL,
	[ActionDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tAttachmentBackup] PRIMARY KEY NONCLUSTERED 
(
	[AttachmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAttachmentBackup] ADD  CONSTRAINT [DF_tAttachmentBackup_ActionDate]  DEFAULT (getutcdate()) FOR [ActionDate]
GO
