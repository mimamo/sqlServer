USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLMSFALookUp_All]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLMSFALookUp_All] @parm1 varchar(20) AS SELECT * FROM vw_PSSLMSFALookUp WHERE AssetID LIKE  @parm1 ORDER BY AssetID
GO
