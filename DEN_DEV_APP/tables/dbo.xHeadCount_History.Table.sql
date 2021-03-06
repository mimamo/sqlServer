USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xHeadCount_History]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xHeadCount_History](
	[HistoryId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MasterId] [int] NOT NULL,
	[CustID] [nvarchar](50) NOT NULL,
	[ProductID] [nvarchar](15) NOT NULL,
	[SubAcct] [int] NOT NULL,
	[FTE] [float] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[Status] [char](1) NOT NULL,
	[FiscalNum] [nvarchar](6) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_User] [nvarchar](50) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_xHeadCount_History] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[SubAcct] ASC,
	[FiscalNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
