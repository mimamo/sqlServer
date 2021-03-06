USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpProjectDetail_SourceDesc]    Script Date: 12/21/2015 14:33:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpProjectDetail_SourceDesc](
	[JobNbr] [nvarchar](6) NULL,
	[Client] [nvarchar](18) NULL,
	[Product] [nvarchar](18) NULL,
	[TaskCd] [nvarchar](21) NULL,
	[RecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Estimate] [float] NULL,
	[TranType] [nvarchar](2) NULL,
	[TranDate] [nvarchar](512) NULL,
 CONSTRAINT [PK_xtmpProjectDetailSourceDesc] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
