USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCurrncy_DecPl]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCurrncy_DecPl] @CuryId varchar(4) As
Select DecPl From Currncy Where Curyid = @CuryId
GO
