USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_OrdNbr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOHeader_OrdNbr]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDSOHeader
 WHERE OrdNbr LIKE @parm1
 ORDER BY OrdNbr
GO
