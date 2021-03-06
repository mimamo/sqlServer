USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[Cognos_Employee_Mapping]    Script Date: 12/21/2015 13:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cognos_Employee_Mapping](
	[Dynamics_Emp_ID] [nchar](10) NOT NULL,
	[Cognos_Dlist_Item] [nchar](50) NULL,
 CONSTRAINT [PK_Cognos_Employee_Mapping] PRIMARY KEY CLUSTERED 
(
	[Dynamics_Emp_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
