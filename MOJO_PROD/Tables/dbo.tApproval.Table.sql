USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApproval]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tApproval](
	[ApprovalKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[Subject] [varchar](200) NOT NULL,
	[Description] [varchar](1000) NULL,
	[DueDate] [smalldatetime] NULL,
	[ViewOtherComments] [tinyint] NOT NULL,
	[ApprovalOrderType] [smallint] NOT NULL,
	[ActiveApprover] [int] NULL,
	[Status] [smallint] NULL,
	[DateCreated] [smalldatetime] NULL,
	[DateSent] [smalldatetime] NULL,
	[SendUpdatesTo] [int] NULL,
 CONSTRAINT [PK_tApproval_1] PRIMARY KEY NONCLUSTERED 
(
	[ApprovalKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tApproval] ADD  CONSTRAINT [DF_tApproval_ViewOtherComments]  DEFAULT ((0)) FOR [ViewOtherComments]
GO
ALTER TABLE [dbo].[tApproval] ADD  CONSTRAINT [DF_tApproval_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
