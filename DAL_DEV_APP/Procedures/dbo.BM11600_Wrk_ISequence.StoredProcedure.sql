USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM11600_Wrk_ISequence]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM11600_Wrk_ISequence] @parm1 integer  as
            Select * from BM11600_Wrk where ISequence = @parm1
           Order by ISequence
GO
