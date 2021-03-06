USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJLabHdr_Det_LEStatus]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJLabHdr_Det_LEStatus]
   @LE_Status  varchar( 1 )
AS
   SELECT      *
   FROM        PJLabHdr LEFT JOIN PJLabDet
               ON PJLabHdr.DocNbr = PJLabDet.DocNbr
   WHERE       PJLabHdr.LE_Status = @LE_Status
   ORDER BY    PJLabHdr.LE_Status, PJLabHdr.Employee, PJLabHdr.DocNbr
GO
