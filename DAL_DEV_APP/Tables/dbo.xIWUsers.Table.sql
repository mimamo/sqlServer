USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xIWUsers]    Script Date: 12/21/2015 13:35:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xIWUsers](
	[ALPerPost] [smallint] NOT NULL,
	[APPerPost] [smallint] NOT NULL,
	[ARPerPost] [smallint] NOT NULL,
	[BCPerPost] [smallint] NOT NULL,
	[BIPerPost] [smallint] NOT NULL,
	[BMPerPost] [smallint] NOT NULL,
	[BUPerPost] [smallint] NOT NULL,
	[CAPerPost] [smallint] NOT NULL,
	[CMPerPost] [smallint] NOT NULL,
	[CNPerPost] [smallint] NOT NULL,
	[COPerPost] [smallint] NOT NULL,
	[DDPerPost] [smallint] NOT NULL,
	[GLPerPost] [smallint] NOT NULL,
	[INPerPost] [smallint] NOT NULL,
	[IQPerPost] [smallint] NOT NULL,
	[OPPerPost] [smallint] NOT NULL,
	[PAPerPost] [smallint] NOT NULL,
	[PCPerPost] [smallint] NOT NULL,
	[POPerPost] [smallint] NOT NULL,
	[PRPerPost] [smallint] NOT NULL,
	[TEPerPost] [smallint] NOT NULL,
	[TMPerPost] [smallint] NOT NULL,
	[PerNbrPlus] [smallint] NOT NULL,
	[PerNbrMin] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[UserName] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
