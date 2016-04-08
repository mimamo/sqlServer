USE [denverapp]
GO

/****** Object:  Table 

drop table [dbo].[DslHoursActual]    


Script Date: 03/31/2016 18:28:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DslHoursActual](
	[DepartmentID] [varchar](24) NULL,
	[DepartmentName] [varchar](30) NULL,
	[ProjectID] [varchar](16) NOT NULL,
	[ProjectDesc] [varchar](60) NULL,
	ClassId varchar(6),
	ClassGroup varchar(10),
	[ClientID] [varchar](30) NOT NULL,
	[ClientName] [varchar](60) NULL,
	[ProductID] [varchar](30) NULL,
	[ProductDesc] [varchar](30) NULL,
	Employee varchar(10),
	[EmployeeName] [varchar](60) NULL,
	[ADPID] [varchar](30) NOT NULL,
	[Title] [varchar](60) NULL,
	[CurMonth] [varchar](2) NULL,
	[CurHours] [float] NULL,
	[CurYear] [int] NULL,
	[fiscalno] [varchar](6) NOT NULL,
	[functionCode] [varchar](32) NULL,
	[WeekEndingDate] [datetime] NULL,
	[company] [varchar](20) NULL,
	[rowId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [pkc_DslHoursActual] PRIMARY KEY CLUSTERED 
(
	[fiscalno] ASC,
	[ClientID] ASC,
	[ADPID] ASC,
	[ProjectID] ASC,
	[rowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


grant select on dslHoursActual to BFGROUP

