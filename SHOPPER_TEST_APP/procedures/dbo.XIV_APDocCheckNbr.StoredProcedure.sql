USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_APDocCheckNbr]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XIV_APDocCheckNbr] 
@parm1 smallint,
@parm2 VarChar(10) As
Select * from APDoc 
where DocClass = "C" and Rlsed >= @parm1 and Refnbr like @parm2
Order by Refnbr
GO
