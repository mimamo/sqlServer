USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[Wrk941S]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk941S](
	[ChkDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[FedWithhold] [float] NOT NULL,
	[FicaWithhold] [float] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Wrk941S0] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ChkDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
