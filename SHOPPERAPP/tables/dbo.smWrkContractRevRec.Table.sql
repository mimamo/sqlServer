USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[smWrkContractRevRec]    Script Date: 12/21/2015 16:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkContractRevRec](
	[BatNbr] [char](10) NOT NULL,
	[ContractId] [char](10) NOT NULL,
	[ContractType] [char](10) NOT NULL,
	[MsgType] [char](1) NOT NULL,
	[UserAddress] [char](21) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
