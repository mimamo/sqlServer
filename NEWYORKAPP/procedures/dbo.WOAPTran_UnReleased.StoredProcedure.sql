USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOAPTran_UnReleased]    Script Date: 12/21/2015 16:01:22 ******/
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
