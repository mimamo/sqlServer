USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xTMADP00_EmpList]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xTMADP00_EmpList](
	[LastName] [nvarchar](255) NULL,
	[FirstName] [nvarchar](255) NULL,
	[HireDate] [datetime] NULL,
	[DepartmentID] [nvarchar](20) NULL,
	[PayGroup] [char](3) NOT NULL,
	[FileNumber] [nvarchar](6) NOT NULL,
	[LocationInfo] [nvarchar](50) NULL,
	[State] [varchar](10) NULL,
	[RateType] [char](1) NULL,
	[APSHourlyRate] [float] NULL,
	[Title] [nvarchar](255) NULL,
	[CoFileNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_ADPEmpList] PRIMARY KEY CLUSTERED 
(
	[PayGroup] ASC,
	[FileNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
