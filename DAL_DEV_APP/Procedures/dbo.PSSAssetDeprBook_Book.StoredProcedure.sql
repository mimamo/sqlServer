USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_Book]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_Book] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10), @parm4 VARCHAR(20) AS
  SELECT * FROM PSSAssetDeprBook WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND BookCode = @parm3 AND DeprMethod LIKE @parm4 ORDER BY DeprMethod
GO
