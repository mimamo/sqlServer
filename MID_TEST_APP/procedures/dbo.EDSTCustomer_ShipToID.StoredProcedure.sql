USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_ShipToID]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSTCustomer_ShipToID]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM EDSTCustomer
 WHERE ShipToID LIKE @parm1
 ORDER BY ShipToID
GO
