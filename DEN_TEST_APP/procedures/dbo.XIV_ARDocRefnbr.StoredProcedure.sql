USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_ARDocRefnbr]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XIV_ARDocRefnbr] @parm1 smallint, @parm2 VarChar(10) As 
Select * from ARDoc 
where DocClass = 'N' and Rlsed >= @parm1 and Refnbr like @parm2 
Order by Refnbr
GO
