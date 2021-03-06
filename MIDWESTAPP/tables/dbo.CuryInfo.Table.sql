USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[CuryInfo]    Script Date: 12/21/2015 15:54:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuryInfo](
	[BaseCuryID] [char](4) NOT NULL,
	[BaseDecPl] [smallint] NOT NULL,
	[CuryView] [smallint] NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[FieldsDisabled] [smallint] NOT NULL,
	[MultDiv] [char](1) NOT NULL,
	[Rate] [float] NOT NULL,
	[RateType] [char](6) NOT NULL,
	[TranCuryId] [char](4) NOT NULL,
	[TranDecPl] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [CuryInfo0] PRIMARY KEY CLUSTERED 
(
	[TranCuryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
