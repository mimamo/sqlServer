USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xIGProdReporting_bak]    Script Date: 12/21/2015 15:42:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xIGProdReporting_bak](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Brand] [varchar](60) NULL,
	[ClientIdentifier] [varchar](60) NULL,
	[channel] [varchar](60) NULL,
	[CognosElistI] [varchar](60) NULL,
	[CognosElistII] [varchar](60) NULL,
	[CognosElistIII] [varchar](60) NULL,
	[CognosElistIV] [varchar](60) NULL,
	[CognosElistV] [varchar](60) NULL,
	[CognosElistVI] [varchar](60) NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_user] [varchar](60) NOT NULL,
	[Director] [varchar](60) NULL,
	[FTEClient] [varchar](60) NULL,
	[FTEBrand] [varchar](60) NULL,
	[GAD] [varchar](60) NULL,
	[HrsTab] [varchar](60) NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [varchar](60) NOT NULL,
	[OOS] [bit] NOT NULL,
	[ProdID] [char](4) NOT NULL,
	[Region] [varchar](60) NULL,
	[Retailer] [varchar](60) NULL,
	[RptClient] [varchar](60) NULL,
	[SubBrand] [varchar](60) NULL,
	[UtlBM] [varchar](60) NULL,
	[UtlCustMktA] [varchar](60) NULL,
	[UtlCustMktB] [varchar](60) NULL,
	[UtlChannel] [varchar](60) NULL,
	[UtlCreative] [varchar](60) NULL,
	[UtlKellogg] [varchar](60) NULL,
	[UtlPG] [varchar](60) NULL,
	[UtlUser1] [varchar](60) NULL,
	[UtlUser2] [varchar](60) NULL,
	[UtlUser3] [varchar](60) NULL,
	[SVP] [varchar](60) NULL,
	[VP] [varchar](60) NULL,
	[WIPGroup] [varchar](60) NULL,
	[timestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
