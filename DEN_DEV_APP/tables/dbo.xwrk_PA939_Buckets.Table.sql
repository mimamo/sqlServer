USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_PA939_Buckets]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_PA939_Buckets](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[JanHours] [float] NOT NULL,
	[FebHours] [float] NOT NULL,
	[MarHours] [float] NOT NULL,
	[AprHours] [float] NOT NULL,
	[MayHours] [float] NOT NULL,
	[JunHours] [float] NOT NULL,
	[JulHours] [float] NOT NULL,
	[AugHours] [float] NOT NULL,
	[SepHours] [float] NOT NULL,
	[OctHours] [float] NOT NULL,
	[NovHours] [float] NOT NULL,
	[DecHours] [float] NOT NULL,
	[TotalHours] [float] NOT NULL,
	[employee] [char](10) NOT NULL,
	[bucket] [varchar](255) NOT NULL,
	[project] [char](16) NOT NULL,
	[Department] [varchar](255) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[detail_num] [int] NOT NULL,
	[system_cd] [char](2) NOT NULL,
	[batch_id] [char](10) NOT NULL,
 CONSTRAINT [PK_xwrk_PA939_Buckets] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
