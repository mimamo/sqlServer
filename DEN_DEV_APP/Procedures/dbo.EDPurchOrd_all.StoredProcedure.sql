USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_all]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDPurchOrd_all]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM EDPurchOrd
 WHERE PONbr LIKE @parm1
 ORDER BY PONbr
GO
