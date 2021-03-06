USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xHeadCount]    Script Date: 12/21/2015 16:00:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xHeadCount](
	[MasterId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CustID] [nvarchar](50) NOT NULL,
	[ProductID] [nvarchar](15) NOT NULL,
	[SubAcct] [int] NOT NULL,
	[FTE] [float] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[Status] [char](1) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_User] [nvarchar](50) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_xHeadCount] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[SubAcct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
