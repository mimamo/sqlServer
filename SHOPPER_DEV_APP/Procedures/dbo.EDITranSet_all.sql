USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDITranSet_all]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDITranSet_all]
 @parm1 varchar( 6 )
AS
 SELECT *
 FROM EDITranSet
 WHERE TranSetID LIKE @parm1
 ORDER BY TranSetID
GO
