USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xExclusion]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xExclusion](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ItemID] [varchar](50) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_user] [varchar](50) NOT NULL,
	[Status] [char](2) NOT NULL,
	[Text1] [nvarchar](2000) NULL,
	[Text2] [nvarchar](2000) NULL,
	[Text3] [nvarchar](2000) NULL,
	[Text4] [nvarchar](2000) NULL,
	[Text5] [nvarchar](2000) NULL,
	[Integer1] [int] NULL,
	[Integer2] [int] NULL,
	[Integer3] [int] NULL,
	[Integer4] [int] NULL,
	[Integer5] [int] NULL,
	[DateTime1] [smalldatetime] NULL,
	[DateTime2] [smalldatetime] NULL,
	[DateTime3] [smalldatetime] NULL,
	[DateTime4] [smalldatetime] NULL,
	[DateTime5] [smalldatetime] NULL,
	[Decimal1] [decimal](18, 0) NULL,
	[Decimal2] [decimal](18, 0) NULL,
	[Decimal3] [decimal](18, 0) NULL,
	[Decimal4] [decimal](18, 0) NULL,
	[Decimal5] [decimal](18, 0) NULL,
	[Guid1] [uniqueidentifier] NULL,
	[Guid2] [uniqueidentifier] NULL,
	[Guid3] [uniqueidentifier] NULL,
	[Guid4] [uniqueidentifier] NULL,
	[Guid5] [uniqueidentifier] NULL,
	[Amount1] [float] NULL,
	[Amount2] [float] NULL,
	[Amount3] [float] NULL,
	[Amount4] [float] NULL,
	[Amount5] [float] NULL,
	[Notes] [varchar](max) NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [varchar](50) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [idx_exclusion0] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
