USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCommodityCode_all]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDCommodityCode_all]
 @parm1 varchar( 30 ),
 @parm2 varchar( 2 ),
 @parm3 varchar( 30 )
AS
 SELECT *
 FROM EDCommodityCode
 WHERE Invtid LIKE @parm1
    AND CommCodeQual LIKE @parm2
    AND CommCode LIKE @parm3
 ORDER BY Invtid,
    CommCodeQual,
    CommCode
GO
