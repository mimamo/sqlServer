USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[NoBatchReport]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[NoBatchReport] @parm1 varchar (10) as
   Select * from Batch where
      batch.batnbr =  @parm1 and
      batch.EditScrnNbr = '08030' and
      batch.CuryCtrlTot = 0 and
      batch.module = 'AR'
GO
