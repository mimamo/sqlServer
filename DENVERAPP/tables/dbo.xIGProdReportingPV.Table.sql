USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xIGProdReportingPV]    Script Date: 12/21/2015 15:42:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xIGProdReportingPV](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NOT NULL,
	[crtd_datetime] [date] NOT NULL,
	[crtd_user] [varchar](60) NOT NULL,
	[Descr] [varchar](60) NOT NULL,
	[lupd_datetime] [date] NOT NULL,
	[lupd_user] [varchar](60) NOT NULL,
	[Type] [varchar](60) NOT NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_xIGProdReportingPV] PRIMARY KEY CLUSTERED 
(
	[Type] ASC,
	[Descr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
