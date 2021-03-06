USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateUser]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateUser](
	[EstimateUserKey] [int] IDENTITY(1,1) NOT NULL,
	[EstimateKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[BillingRate] [money] NOT NULL,
	[Cost] [money] NULL,
 CONSTRAINT [PK_tEstimateUser] PRIMARY KEY NONCLUSTERED 
(
	[EstimateUserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateUser]  WITH CHECK ADD  CONSTRAINT [FK_tEstimateUser_tEstimate] FOREIGN KEY([EstimateKey])
REFERENCES [dbo].[tEstimate] ([EstimateKey])
GO
ALTER TABLE [dbo].[tEstimateUser] CHECK CONSTRAINT [FK_tEstimateUser_tEstimate]
GO
ALTER TABLE [dbo].[tEstimateUser] ADD  CONSTRAINT [DF_tEstimateUser_BillingRate]  DEFAULT ((0)) FOR [BillingRate]
GO
