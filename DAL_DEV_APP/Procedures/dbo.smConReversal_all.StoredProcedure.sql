USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConReversal_all]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConReversal_all]  
        @parm1 varchar( 10 ),  
        @parm2min smallint, @parm2max smallint  
AS  
        SELECT *  
        FROM smConReversal  
        WHERE BatNbr LIKE @parm1  
           AND LineNbr BETWEEN @parm2min AND @parm2max  
        ORDER BY BatNbr,  
           LineNbr
GO
