USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[CorrectedEmployeeMasterFile]    Script Date: 12/21/2015 14:10:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CorrectedEmployeeMasterFile](
	[employee] [nvarchar](255) NULL,
	[emp_name] [nvarchar](255) NULL,
	[gl_subacct] [float] NULL,
	[New Sub Account] [float] NULL
) ON [PRIMARY]
GO
