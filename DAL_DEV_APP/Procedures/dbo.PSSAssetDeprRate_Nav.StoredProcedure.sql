USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprRate_Nav]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprRate_Nav] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10), @parm4 VARCHAR(10), @parm5 VARCHAR(24) AS
  SELECT * FROM PSSAssetDeprRate WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND BookCode = @parm3 AND BookSeq = @parm4 AND SubAcct LIKE @parm5 ORDER BY subacct
GO
