USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalList]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tApprovalList](
	[ApprovalKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ApprovalOrder] [int] NULL,
	[Completed] [tinyint] NULL,
 CONSTRAINT [PK_tApprovalList_1] PRIMARY KEY NONCLUSTERED 
(
	[ApprovalKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tApprovalList]  WITH NOCHECK ADD  CONSTRAINT [FK_tApprovalList_tApproval] FOREIGN KEY([ApprovalKey])
REFERENCES [dbo].[tApproval] ([ApprovalKey])
GO
ALTER TABLE [dbo].[tApprovalList] CHECK CONSTRAINT [FK_tApprovalList_tApproval]
GO
ALTER TABLE [dbo].[tApprovalList] ADD  CONSTRAINT [DF_tApprovalList_Completed]  DEFAULT ((0)) FOR [Completed]
GO
