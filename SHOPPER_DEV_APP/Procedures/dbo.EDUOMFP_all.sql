USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDUOMFP_all]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDUOMFP_all]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDUOMFP
 WHERE Dimension LIKE @parm1
 ORDER BY Dimension
GO
