USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_Verify]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850HeaderExt_Verify] @ISANbr int, @STNbr int As
Select Count(*) From ED850HeaderExt Where ISANbr = @ISANbr And STNbr = @STNbr
GO
