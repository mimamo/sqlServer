USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDBOLWRK_all]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDBOLWRK_all]
 @parm1 varchar( 20 ),
 @parm2 varchar( 20 )
AS
 SELECT *
 FROM EDBOLWRK
 WHERE BOLNBR LIKE @parm1
    AND BOLCLASS LIKE @parm2
 ORDER BY BOLNBR,
    BOLCLASS
GO
