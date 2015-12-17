USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_DuplicateChk]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_DuplicateChk] @InvcNbr varchar(15), @GSNbr int, @IsaNbr int, @STNbr int As
Select EDIInvId From ED810Header Where InvcNbr = @InvcNbr And GSNbr = @GSNbr And IsaNbr = @IsaNbr
And StNbr = @StNbr
GO
