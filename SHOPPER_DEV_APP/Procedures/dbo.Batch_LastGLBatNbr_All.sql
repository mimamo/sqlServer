USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_LastGLBatNbr_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_LastGLBatNbr_All    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc  [dbo].[Batch_LastGLBatNbr_All] as
Select * from Batch
where Module  =  'GL'
order by Module DESC, BatNbr DESC
GO
