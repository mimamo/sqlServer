USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalItemReply]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tApprovalItemReply](
	[ApprovalItemReplyKey] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalItemKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[Comments] [text] NULL,
	[DateUpdated] [smalldatetime] NULL,
 CONSTRAINT [PK_tApprovalItemReply_1] PRIMARY KEY NONCLUSTERED 
(
	[ApprovalItemReplyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tApprovalItemReply]  WITH CHECK ADD  CONSTRAINT [FK_tApprovalItemReply_tApprovalItem] FOREIGN KEY([ApprovalItemKey])
REFERENCES [dbo].[tApprovalItem] ([ApprovalItemKey])
GO
ALTER TABLE [dbo].[tApprovalItemReply] CHECK CONSTRAINT [FK_tApprovalItemReply_tApprovalItem]
GO
