USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CM_CurrencyValidate]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[FMG_CM_CurrencyValidate]  @CurrencyId varchar (4)As
IF
    (Select Count(*) FROM GLSetup WHERE BaseCuryID = @CurrencyId) > 0 or
    (Select Count(*) FROM Batch   WHERE BaseCuryID = @CurrencyId Or CuryId = @CurrencyId) > 0
   SELECT 9
ELSE
     SELECT 0
GO
