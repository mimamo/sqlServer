USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_LastGLBatNbr]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_LastGLBatNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc  [dbo].[Batch_LastGLBatNbr] as
       Select BatNbr from Batch
           where Module  =  'GL'
           order by Module DESC, BatNbr DESC
GO
