USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_BatType_DD_Clrd]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Batch_Module_BatType_DD_Clrd] as
    Select * from Batch where Module = 'PR' and BatType = 'N' and JrnlType = 'DD' and Cleared = 0 order by BatNbr
GO
