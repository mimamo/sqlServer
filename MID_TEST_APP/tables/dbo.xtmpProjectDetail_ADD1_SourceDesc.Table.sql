USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpProjectDetail_ADD1_SourceDesc]    Script Date: 12/21/2015 14:26:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpProjectDetail_ADD1_SourceDesc](
	[JobNbr] [nvarchar](50) NULL,
	[Client] [nvarchar](50) NULL,
	[Product] [nvarchar](50) NULL,
	[TaskCd] [nvarchar](50) NULL,
	[RecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Estimate] [float] NULL,
	[TranType] [nvarchar](50) NULL,
	[TranDate] [nvarchar](max) NULL,
 CONSTRAINT [PK_xtmpProjectDetail_ADD1_SourceDesc] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
