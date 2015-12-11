USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFormSubscription]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tFormSubscription](
	[FormSubscriptionKey] [int] IDENTITY(1,1) NOT NULL,
	[FormKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
 CONSTRAINT [PK_tFormSubscription] PRIMARY KEY NONCLUSTERED 
(
	[FormSubscriptionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tFormSubscription]  WITH NOCHECK ADD  CONSTRAINT [FK_tFormSubscription_tForm] FOREIGN KEY([FormKey])
REFERENCES [dbo].[tForm] ([FormKey])
GO
ALTER TABLE [dbo].[tFormSubscription] CHECK CONSTRAINT [FK_tFormSubscription_tForm]
GO
