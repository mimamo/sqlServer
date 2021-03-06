USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJPENTEM]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPENTEM](
	[Actual_amt] [float] NOT NULL,
	[Actual_units] [float] NOT NULL,
	[Budget_amt] [float] NOT NULL,
	[Budget_units] [float] NOT NULL,
	[Comment] [char](50) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[Date_start] [smalldatetime] NOT NULL,
	[Date_end] [smalldatetime] NOT NULL,
	[Employee] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[MSPSync] [char](1) NOT NULL,
	[noteid] [int] NOT NULL,
	[Pjt_entity] [char](32) NOT NULL,
	[Project] [char](16) NOT NULL,
	[Revadj_amt] [float] NOT NULL,
	[Revenue_amt] [float] NOT NULL,
	[SubTask_Name] [char](50) NOT NULL,
	[SubTask_UID] [int] NOT NULL,
	[Tk_id01] [char](30) NOT NULL,
	[Tk_id02] [char](30) NOT NULL,
	[Tk_id03] [char](16) NOT NULL,
	[Tk_id04] [char](16) NOT NULL,
	[Tk_id05] [char](4) NOT NULL,
	[Tk_id06] [float] NOT NULL,
	[Tk_id07] [float] NOT NULL,
	[Tk_id08] [smalldatetime] NOT NULL,
	[Tk_id09] [smalldatetime] NOT NULL,
	[Tk_id10] [int] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpentem0] PRIMARY KEY CLUSTERED 
(
	[Project] ASC,
	[Pjt_entity] ASC,
	[Employee] ASC,
	[SubTask_Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
