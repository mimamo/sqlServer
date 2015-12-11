USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewRound]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReviewRound](
	[ReviewRoundKey] [int] IDENTITY(1,1) NOT NULL,
	[ReviewDeliverableKey] [int] NULL,
	[TaskKey] [int] NULL,
	[CompleteTaskWhenDone] [tinyint] NULL,
	[DueDate] [smalldatetime] NULL,
	[WorkflowType] [tinyint] NULL,
	[Status] [int] NULL,
	[DateSent] [datetime] NULL,
	[SentByUserKey] [int] NULL,
	[RoundName] [varchar](50) NULL,
	[CancelledDate] [datetime] NULL,
	[CancelledByUserKey] [int] NULL,
	[Files] [varchar](4000) NULL,
	[CompletedDate] [datetime] NULL,
	[RejectedDate] [datetime] NULL,
	[LatestRound] [tinyint] NULL,
	[DateCreated] [smalldatetime] NULL,
	[FilesDeleted] [tinyint] NULL,
	[Metadata] [varchar](max) NULL,
	[PickFavorite] [tinyint] NULL,
 CONSTRAINT [PK_tReviewRound] PRIMARY KEY CLUSTERED 
(
	[ReviewRoundKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tReviewRound]  WITH CHECK ADD  CONSTRAINT [FK_tReviewRound_tReviewDeliverable] FOREIGN KEY([ReviewDeliverableKey])
REFERENCES [dbo].[tReviewDeliverable] ([ReviewDeliverableKey])
GO
ALTER TABLE [dbo].[tReviewRound] CHECK CONSTRAINT [FK_tReviewRound_tReviewDeliverable]
GO
ALTER TABLE [dbo].[tReviewRound] ADD  CONSTRAINT [DF_tReviewRound_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
