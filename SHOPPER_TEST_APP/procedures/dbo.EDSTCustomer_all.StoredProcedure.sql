USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_all]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSTCustomer_all]
 @parm1 varchar( 15 ),
 @parm2 varchar( 10 )
AS
 SELECT *
 FROM EDSTCustomer
 WHERE CustID LIKE @parm1
    AND ShipToID LIKE @parm2
 ORDER BY CustID,
    ShipToID
GO
