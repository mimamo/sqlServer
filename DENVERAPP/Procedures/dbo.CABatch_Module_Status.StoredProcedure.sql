USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CABatch_Module_Status]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CABatch_Module_Status    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[CABatch_Module_Status] @parm1 varchar(10) As
Select * from Batch, Currncy
where Batch.CuryId = Currncy.CuryId
and Module  = 'CA'
and Batch.CpnyID like @parm1
and Batch.Status IN ('I', 'S', 'B')
Order by CpnyID, Module, BatNbr, Batch.Status
GO
