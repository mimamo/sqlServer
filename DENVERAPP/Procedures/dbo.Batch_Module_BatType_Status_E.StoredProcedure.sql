USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_BatType_Status_E]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Batch_Module_BatType_Status_E] as
    Select * from Batch where Module = 'PR' and BatType = 'N' and Status IN('R','K') and EditScrnNbr = '02630' order by BatNbr
GO
