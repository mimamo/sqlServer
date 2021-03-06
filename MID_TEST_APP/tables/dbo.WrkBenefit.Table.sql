USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[WrkBenefit]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkBenefit](
	[BenId] [char](10) NOT NULL,
	[BenType] [char](1) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[EarnTypeId] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[MaxCarryOver] [float] NOT NULL,
	[MaxCumAvail] [float] NOT NULL,
	[MonthsEmp] [smallint] NOT NULL,
	[NoteId] [int] NOT NULL,
	[RateAnn] [float] NOT NULL,
	[RateBwk] [float] NOT NULL,
	[RateHour] [float] NOT NULL,
	[RateMon] [float] NOT NULL,
	[RateSmon] [float] NOT NULL,
	[RateWeek] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkBenefit0] PRIMARY KEY CLUSTERED 
(
	[BenId] ASC,
	[LineNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
