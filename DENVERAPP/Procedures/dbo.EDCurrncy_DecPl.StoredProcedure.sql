USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCurrncy_DecPl]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCurrncy_DecPl] @CuryId varchar(4) As
Select DecPl From Currncy Where Curyid = @CuryId
GO
