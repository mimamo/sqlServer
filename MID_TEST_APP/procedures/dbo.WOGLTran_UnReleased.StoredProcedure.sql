USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOGLTran_UnReleased]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOGLTran_UnReleased]
   @PerPost    varchar( 6 )

AS
   SELECT      *
   FROM        GLTran
   WHERE       Module = 'GL' and
               PerPost = @PerPost and
               PC_Status = '1'
   ORDER BY    Module, PerPost, Rlsed, TranType
GO
