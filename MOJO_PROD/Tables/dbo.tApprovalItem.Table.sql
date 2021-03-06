USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalItem]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tApprovalItem](
	[ApprovalItemKey] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalKey] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[ItemName] [varchar](200) NOT NULL,
	[Description] [varchar](6000) NULL,
	[FileType] [smallint] NOT NULL,
	[Visible] [tinyint] NOT NULL,
	[AttachmentKey] [int] NULL,
	[URL] [varchar](1000) NULL,
	[URLName] [varchar](300) NULL,
	[FileHeight] [int] NULL,
	[FileWidth] [int] NULL,
	[WindowHeight] [int] NULL,
	[WindowWidth] [int] NULL,
	[WindowBackground] [varchar](50) NULL,
	[Position] [int] NULL,
	[AttachmentType] [smallint] NULL,
	[FileVersionKey] [int] NULL,
 CONSTRAINT [PK_tApprovalItem_1] PRIMARY KEY NONCLUSTERED 
(
	[ApprovalItemKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tApprovalItem] ADD  CONSTRAINT [DF_tApprovalItem_DisplayOrder]  DEFAULT ((1)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[tApprovalItem] ADD  CONSTRAINT [DF_tApprovalItem_FileType]  DEFAULT ((1)) FOR [FileType]
GO
ALTER TABLE [dbo].[tApprovalItem] ADD  CONSTRAINT [DF_tApprovalItem_Visible]  DEFAULT ((1)) FOR [Visible]
GO
ALTER TABLE [dbo].[tApprovalItem] ADD  CONSTRAINT [DF_tApprovalItem_AttachmentType]  DEFAULT ((0)) FOR [AttachmentType]
GO
