USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLMSFASub_All]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLMSFASub_All] @parm1 varchar(20), @parm2 varchar(20) AS SELECT * FROM vw_PSSLMSFASubLookUp WHERE AssetSubID LIKE @parm1 and AssetID LIKE  @parm2 ORDER BY AssetID
GO
