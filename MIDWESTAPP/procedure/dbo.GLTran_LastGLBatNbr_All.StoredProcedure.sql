USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_LastGLBatNbr_All]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[GLTran_LastGLBatNbr_All] as
Select * from GLTran
where Module  =  'GL'
order by Module DESC, BatNbr DESC
GO
