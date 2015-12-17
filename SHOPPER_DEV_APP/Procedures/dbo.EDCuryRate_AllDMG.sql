USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCuryRate_AllDMG]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCuryRate_AllDMG] @TranCuryId varchar(4), @BaseCuryId varchar(4) As
Select * From CuryRate Where (FromCuryId = @TranCuryId And ToCuryId = @BaseCuryId) Or (FromCuryId = @BaseCuryId And ToCuryId = @TranCuryId) Order By EffDate Desc
GO
