USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_RefNbr]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_RefNbr] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSAssetDeprBook WHERE AssetSubID LIKE @parm1 ORDER BY AssetSubID
GO
