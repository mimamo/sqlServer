USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOAPTran_UnReleased]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOAPTran_UnReleased]
   @PerPost    varchar( 6 )

AS
   SELECT      *
   FROM        APTran
   WHERE       PerPost = @PerPost and
               PC_Status = '1'
   ORDER BY    PerPost, Rlsed, CostType
GO
