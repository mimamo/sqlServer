USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJChargH_Update_Status]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJChargH_Update_Status]
   @Batch_ID		varchar( 10 ),
   @Batch_Status	varchar( 1 )

AS
   UPDATE		PJChargH
   SET			Batch_Status = @Batch_Status
   WHERE    		Batch_ID LIKE @Batch_ID
GO
