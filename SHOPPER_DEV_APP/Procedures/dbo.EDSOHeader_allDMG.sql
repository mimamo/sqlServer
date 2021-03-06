USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_allDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDSOHeader_all    Script Date: 5/28/99 1:17:45 PM ******/
CREATE PROCEDURE [dbo].[EDSOHeader_allDMG]
 @parm1 varchar( 10 ),
 @parm2 varchar( 15 )
AS
 SELECT *
 FROM EDSOHeader
 WHERE CpnyId LIKE @parm1
    AND OrdNbr LIKE @parm2
 ORDER BY CpnyId,
    OrdNbr
GO
