USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_Verify]    Script Date: 12/21/2015 15:49:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850HeaderExt_Verify] @ISANbr int, @STNbr int As
Select Count(*) From ED850HeaderExt Where ISANbr = @ISANbr And STNbr = @STNbr
GO
