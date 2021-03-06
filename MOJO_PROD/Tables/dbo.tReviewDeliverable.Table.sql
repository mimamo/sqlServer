USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewDeliverable]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReviewDeliverable](
	[ReviewDeliverableKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[DeliverableName] [varchar](1000) NULL,
	[Description] [text] NULL,
	[ProjectKey] [int] NULL,
	[OwnerKey] [int] NULL,
	[DueDate] [smalldatetime] NULL,
	[LastCompletedRoundKey] [int] NULL,
	[Approved] [tinyint] NULL,
	[ApprovedDate] [smalldatetime] NULL,
	[ReActivatedDate] [smalldatetime] NULL,
	[MaxNumberOfRounds] [int] NULL,
	[TaskKey] [int] NULL,
	[DeliverableGroupKey] [int] NULL,
	[DeliverableGroupOrder] [int] NULL,
	[Completed] [tinyint] NULL,
 CONSTRAINT [PK_tReviewDeliverable] PRIMARY KEY CLUSTERED 
(
	[ReviewDeliverableKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
