USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APBatch_Module_Status]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APBatch_Module_Status    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APBatch_Module_Status] As
Select * from Batch, Currncy where Module  = 'AP'
and Batch.Status IN ('I', 'S', 'B')
and Batch.CuryID = Currncy.CuryID
GO
