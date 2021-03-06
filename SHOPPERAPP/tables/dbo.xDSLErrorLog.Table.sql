USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xDSLErrorLog]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xDSLErrorLog](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorSeverity] [int] NOT NULL,
	[ErrorState] [varchar](255) NOT NULL,
	[ErrorProcedure] [varchar](255) NOT NULL,
	[ErrorLine] [int] NOT NULL,
	[ErrorMessage] [varchar](max) NOT NULL,
	[ErrorDate] [smalldatetime] NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[ErrorApp] [varchar](50) NOT NULL,
	[UserMachineName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
