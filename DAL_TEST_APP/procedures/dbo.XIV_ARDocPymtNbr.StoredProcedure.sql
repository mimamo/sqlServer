USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_ARDocPymtNbr]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XIV_ARDocPymtNbr] @parm1 smallint, @parm2 VarChar(10) As 
Select * from ARDoc 
where DocClass = 'P' and Rlsed >= @parm1 and Refnbr like @parm2 
Order by Refnbr
GO
