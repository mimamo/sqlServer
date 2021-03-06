USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMBatch_Mod_INStatus3]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMBatch_Mod_INStatus3] @Module varchar ( 2) as
       Select * from Batch
           Where Module = @Module
             and Status IN ('B', 'S', 'I')
             and JrnlType = 'BM'
           order by BatNbr, Status
GO
