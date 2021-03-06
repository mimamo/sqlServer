USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWIPPostingDetail]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWIPPostingDetail](
	[WIPPostingKey] [int] NOT NULL,
	[Entity] [varchar](100) NOT NULL,
	[EntityKey] [int] NULL,
	[UIDEntityKey] [uniqueidentifier] NULL,
	[TransactionKey] [int] NOT NULL,
	[Amount] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWIPPostingDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_tWIPPostingDetail_tWIPPosting] FOREIGN KEY([WIPPostingKey])
REFERENCES [dbo].[tWIPPosting] ([WIPPostingKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tWIPPostingDetail] CHECK CONSTRAINT [FK_tWIPPostingDetail_tWIPPosting]
GO
