USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaDayPart]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaDayPart](
	[MediaDayPartKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[POKind] [smallint] NOT NULL,
	[DayPartID] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[TimeRange] [varchar](50) NULL,
	[Prime] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[MediaDayKey] [int] NULL,
 CONSTRAINT [PK_tMediaDayPart] PRIMARY KEY CLUSTERED 
(
	[MediaDayPartKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
