USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_Verify]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_Verify] @ISANbr int, @STNbr int, @GSRcvId varchar(15), @GSSenderId varchar(15) As
Select Count(*) From ED810Header Where ISANbr = @ISANbr And STNbr = @STNbr
GO
