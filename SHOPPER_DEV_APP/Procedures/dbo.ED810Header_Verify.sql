USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_Verify]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_Verify] @ISANbr int, @STNbr int, @GSRcvId varchar(15), @GSSenderId varchar(15) As
Select Count(*) From ED810Header Where ISANbr = @ISANbr And STNbr = @STNbr
GO
