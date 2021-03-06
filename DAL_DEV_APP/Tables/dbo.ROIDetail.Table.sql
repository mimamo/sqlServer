USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[ROIDetail]    Script Date: 12/21/2015 13:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROIDetail](
	[CriteriaLVal] [char](100) NOT NULL,
	[CriteriaOp] [char](11) NOT NULL,
	[Field] [char](41) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Operator] [char](3) NOT NULL,
	[PageBreak] [smallint] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SortAscend] [smallint] NOT NULL,
	[SortNbr] [smallint] NOT NULL,
	[TotalBreak] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [ROIDetail0] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[LineNbr] ASC,
	[LineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
