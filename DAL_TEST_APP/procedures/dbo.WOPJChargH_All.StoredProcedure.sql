USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJChargH_All]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJChargH_All]
   @Batch_ID   varchar( 10 )

AS
   SELECT      *
   FROM     	PJChargH
   WHERE    	Batch_ID LIKE @Batch_ID
   ORDER BY    Batch_ID
GO
