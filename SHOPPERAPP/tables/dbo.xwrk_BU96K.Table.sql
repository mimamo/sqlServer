USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_BU96K]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BU96K](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[RunDate] [varchar](12) NOT NULL,
	[RunTime] [varchar](12) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[RecordType] [varchar](12) NOT NULL,
	[Project] [varchar](16) NOT NULL,
	[RevID] [varchar](4) NOT NULL,
	[Status] [varchar](2) NOT NULL,
	[FunctionCode] [varchar](32) NOT NULL,
	[Amount] [float] NOT NULL,
	[Units] [float] NOT NULL,
	[Acct] [varchar](16) NOT NULL,
	[ProjectNoteID] [int] NULL,
	[TaskNoteID] [int] NULL,
	[ProjectNote] [text] NULL,
	[TaskNote] [text] NULL,
 CONSTRAINT [PK_xwrk_BU96K] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
